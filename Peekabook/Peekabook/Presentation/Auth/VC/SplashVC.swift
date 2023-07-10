//
//  SplashVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/13.
//

import UIKit

import SnapKit

final class SplashVC: UIViewController {
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.Image.logo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setNavigationBar()
        self.setLayout()
        self.checkDidSignIn()
    }
}

// MARK: - Methods

extension SplashVC {
    
    private func checkDidSignIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if UserManager.shared.hasAccessToken {
                self.pushToTabBarController()
            } else {
                self.pushToOnboardingVC()
            }
        }
    }
    
    private func pushToOnboardingVC() {
        let onboardingVC = OnboardingVC()
        self.navigationController?.pushViewController(onboardingVC, animated: false)
    }
    
    private func pushToTabBarController() {
        let tabBarController = TabBarController()
        guard let window = self.view.window else { return }
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

// MARK: - UI & Layout

extension SplashVC {
    private func setUI() {
        view.backgroundColor = .peekaBeige
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayout() {
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(100)
            $0.center.equalToSuperview()
        }
    }
}
