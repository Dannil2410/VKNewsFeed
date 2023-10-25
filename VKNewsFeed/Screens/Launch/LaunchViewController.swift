//
//  LaunchViewController.swift
//  VKNewsFeed
//
//  Created by Даниил Кизельштейн on 13.10.2023.
//

import UIKit
import SnapKit

final class LaunchViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var vkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60, weight: .semibold)
        label.textColor = .purple
        label.text = "VK"
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .purple
        return button
    }()
    
    private weak var delegate: LaunchViewControllerDelegate?
    
    //MARK: - Init
    init(delegate: LaunchViewControllerDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Lifecircle
    override func loadView() {
        view = GradientView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureVkLabel()
        configureLoginButton()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        loginButton.layer.cornerRadius = loginButton.bounds.height/4
        
        updateConstraintsByRotation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationAppearUI()
    }
    
    private func updateConstraintsByRotation() {
        vkLabel.snp.updateConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(view.bounds.height/8)
        }

        loginButton.snp.updateConstraints {
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(view.bounds.width/4)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-view.bounds.height/8)
        }
    }
    
    //MARK: - Configuration UI
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureVkLabel() {
        view.addSubview(vkLabel)
        
        vkLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(view.bounds.height/8)
        }
    }
    
    private func configureLoginButton() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-view.bounds.height/8)
            $0.width.equalTo(view.safeAreaLayoutGuide).inset(view.bounds.width/4)
            $0.height.equalTo(50)
        }
        
        loginButton.addTarget(self, action: #selector(moveToAuthViewController), for: .touchUpInside)
    }
    
    //MARK: - Animation
    private func animationAppearUI() {
        vkLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        loginButton.layer.opacity = 0
        
        UIView.animate(
            withDuration: 2,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.4) {
                self.vkLabel.transform = .identity
            }
        
        UIView.animate(
            withDuration: 1,
            delay: 0) {
                self.loginButton.layer.opacity = 1
            }
        
    }
    
    //MARK: - Selectors
    @objc
    private func moveToAuthViewController() {
        delegate?.moveToAuthViewController()
    }
}
