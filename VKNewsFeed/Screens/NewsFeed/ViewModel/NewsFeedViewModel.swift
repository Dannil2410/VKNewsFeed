//
//  NewsFeedViewModel.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 14.10.2023.
//

import Foundation
import Combine

enum UpdateTableView {
    case reloadData
    case reloadRows([IndexPath])
}

enum LoadType {
    case new
    case firstTime
    case previous
}

final class NewsFeedViewModel {
    
    //MARK: - Private Properties
    
    private let mapper: NewsFeedCellModelProtocol
    
    private let dataFetcherService: DataFetcher
    
    private var moreTextButtonPressedIndexPaths = [Int]()
    
    private var newsFeedModel = NewsFeedResponseModel.mockObject
    
    private var cancellables = Set<AnyCancellable>()
    private var updateTableViewSubject = PassthroughSubject<UpdateTableView, Never>()
    
    //MARK: - Public Properties
    
    var updateTableViewPublisher: AnyPublisher<UpdateTableView, Never> {
        updateTableViewSubject
            .eraseToAnyPublisher()
    }
    
    @Published var userAvatarModel: UserAvatarModelProtocol?
    
    var heightForIndexPath = [Int: CGFloat]()

    var feedsCount: Int {
        newsFeedModel.items.count
    }
    
    //MARK: - init
    
    init(dataFetcherService: DataFetcher, mapper: NewsFeedCellModelProtocol = Mapper()) {
        self.dataFetcherService = dataFetcherService
        self.mapper = mapper
        
        getNotifications()
    }
    
    //MARK: - Business logic
    
    func getNotifications() {
        NotificationCenter.default.publisher(for: NewsFeedCell.moreTextButtonNotification)
            .compactMap { notification in
                notification.userInfo?["indexPath"] as? IndexPath
            }
            .sink { indexPath in
                let postId = self.getPostId(forIndexPath: indexPath)
                self.moreTextButtonPressedIndexPaths.append(postId)
                self.updateTableViewSubject.send(.reloadRows([indexPath]))
            }
            .store(in: &cancellables)
    }

    func fetchNewsFeed(loadType: LoadType) {
        dataFetcherService.getNewsFeed(
            nextFrom: loadType == .previous ? newsFeedModel.nextFrom : nil
        )
        .map { $0.response }
        .sink { completion in
            switch completion {
            case .finished:
                print("Fetch newsfeed successfully finished")
            case let .failure(error):
                print(error.errorMessageString)
            }
        } receiveValue: { [weak self] newsFeedResponse in
            guard let self else { return }
            self.updateNewsFeedModel(loadType, newsFeedResponse)
            self.updateTableViewSubject.send(.reloadData)
        }
        .store(in: &cancellables)
    }
    
    func fetchUserProfile() {
        dataFetcherService.getUserAvatar()
            .map { $0.response }
            .sink { completion in
                switch completion {
                case .finished:
                    print("Fetch newsfeed successfully finished")
                case let .failure(error):
                    print(error.errorMessageString)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.userAvatarModel = UserAvatarModel(avatarUrlString: response.items.first?.photoUrlString)
            }
            .store(in: &cancellables)
    }
    
    func newsFeedCellModel(for indexPath: IndexPath) -> NewsFeedCellModel {
        let postId = getPostId(forIndexPath: indexPath)
        let moreTextButtonPressed = moreTextButtonPressedIndexPaths.contains(postId)
        let newsFeedCellModel = mapper.createNewsFeedCellModel(
            for: indexPath,
            newsFeedModel: newsFeedModel,
            moreTextButtonPressed: moreTextButtonPressed
        )
        heightForIndexPath[postId] = newsFeedCellModel.sizes.totalHeight
        return newsFeedCellModel
    }
    
    func getPostId(forIndexPath indexPath: IndexPath) -> Int {
        newsFeedModel.items[indexPath.row].postId
    }
    
    private func updateNewsFeedModel(_ loadType: LoadType, _ newsFeedResponse: NewsFeedResponseModel) {
        switch loadType {
        case .new:
            newsFeedModel.items = newsFeedResponse.items + newsFeedModel.items
            updateGroupsProfiles(newsFeedResponse)
        case .firstTime:
            newsFeedModel = newsFeedResponse
        case .previous:
            newsFeedModel.items.append(contentsOf: newsFeedResponse.items)
            newsFeedModel.nextFrom = newsFeedResponse.nextFrom
            updateGroupsProfiles(newsFeedResponse)
        }
    }
    
    private func updateGroupsProfiles(_ newsFeedResponse: NewsFeedResponseModel) {
        var profiles = newsFeedResponse.profiles
        let oldFilteredProfiles = newsFeedModel.profiles.filter { oldProfile in
            !profiles.contains(where: { $0.id == oldProfile.id })
        }
        profiles.append(contentsOf: oldFilteredProfiles)
        newsFeedModel.profiles = profiles
        
        var groups = newsFeedResponse.groups
        let oldFilteredGroups = newsFeedModel.groups.filter { oldGroup in
            !groups.contains(where: { $0.id == oldGroup.id })
        }
        groups.append(contentsOf: oldFilteredGroups)
        newsFeedModel.groups = groups
    }
}
