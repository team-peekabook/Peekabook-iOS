//
//  LoginVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/30.
//

import UIKit

import AuthenticationServices
import SnapKit
import Then

import Moya

final class LoginVC: UIViewController {

    // MARK: - UI Components
    
    private let logoImgView = UIImageView().then {
        $0.image = ImageLiterals.Image.appLogo
    }
    
    private lazy var kakaoLoginButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.kakaoButton, for: .normal)
        $0.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
        return button
    }()

    private let infoLabel = UILabel().then {
        $0.text = I18N.Login.info
        $0.font = .s2
        $0.textColor = .peekaGray1
    }
    
    private let labelContainerView = UIView()
    
    private lazy var serviceTermsButton = UIButton().then {
        $0.setTitle(I18N.Login.serviceTerms, for: .normal)
        $0.titleLabel!.font = .s1
        $0.setTitleColor(.peekaGray2, for: .normal)
        $0.addTarget(self, action: #selector(serviceTermsButtonDidtap), for: .touchUpInside)
    }
    
    private let andLabel = UILabel().then {
        $0.text = I18N.Login.and
        $0.font = .s2
        $0.textColor = .peekaGray1
    }
    
    private lazy var privacyPolicyButton = UIButton().then {
        $0.setTitle(I18N.Login.privacyPolicy, for: .normal)
        $0.titleLabel!.font = .s1
        $0.setTitleColor(.peekaGray2, for: .normal)
        $0.addTarget(self, action: #selector(privacyPolicyButtonDidtap), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setLayout()
    }
}

// MARK: - UI & Layout

extension LoginVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(logoImgView, kakaoLoginButton, appleLoginButton, infoLabel, labelContainerView)
        labelContainerView.addSubviews(serviceTermsButton, andLabel, privacyPolicyButton)
        
        logoImgView.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-191)
            $0.centerX.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(45)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.top).offset(-31)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(45)
        }
        
        infoLabel.snp.makeConstraints {
            $0.bottom.equalTo(labelContainerView.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16)
        }

        labelContainerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(59)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(157)
            $0.height.equalTo(16)
        }

        andLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        serviceTermsButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(andLabel.snp.leading).offset(-4)
        }

        privacyPolicyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(andLabel.snp.trailing).offset(4)
        }
    }
}

// MARK: - Methods

extension LoginVC {
    // MARK: - @objc Function
    
    @objc private func kakaoLoginButtonDidTap() {
        print("카카오 로그인")
    }
    
    @objc private func appleLoginButtonDidTap() {
        print("애플 로그인")
    }
    
    @objc private func serviceTermsButtonDidtap() {
        print("서비스 이용약관")
    }
    
    @objc private func privacyPolicyButtonDidtap() {
        print("개인정보 정책")
    }
}
