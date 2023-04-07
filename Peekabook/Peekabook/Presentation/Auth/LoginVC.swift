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

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

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
    
    private let serviceTermsLabel = UILabel().then {
        $0.text = I18N.Login.serviceTerms
        $0.font = .s1
        $0.textColor = .peekaGray2
    }
    
    private let andLabel = UILabel().then {
        $0.text = I18N.Login.and
        $0.font = .s2
        $0.textColor = .peekaGray1
    }
    
    private let privacyPolicyLabel = UILabel().then {
        $0.text = I18N.Login.privacyPolicy
        $0.font = .s1
        $0.textColor = .peekaGray2
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonTapGesture()
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
        labelContainerView.addSubviews(serviceTermsLabel, andLabel, privacyPolicyLabel)
        
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

        serviceTermsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        andLabel.snp.makeConstraints {
            $0.leading.equalTo(serviceTermsLabel.snp.trailing).offset(4)
            $0.centerY.equalToSuperview()
        }

        privacyPolicyLabel.snp.makeConstraints {
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
        
        checkIfKakaoInstalled()
    }
    
    @objc private func appleLoginButtonDidTap() {
        print("애플 로그인")
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func addButtonTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveTotermsAndpolicy))
        labelContainerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func moveTotermsAndpolicy() {
        print("서비스 이용약관 및 정책")
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        // 페이스 아이디로 로그인
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authString = String(data: authorizationCode, encoding: .utf8),
                let tokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authString: \(authString)")
                print("tokenString: \(tokenString)")
                Config.accessToken = tokenString
            }
            
            let appleLoginRequest = SocialLoginRequest(socialPlatform: "apple")
            appleLogin(param: appleLoginRequest)
            
        // 비밀번호로 로그인
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
            let appleLoginRequest = SocialLoginRequest(socialPlatform: "apple")
            appleLogin(param: appleLoginRequest)
            
        default:
            break
        }
    }
    
    // 로그인 실패시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login err")
    }
}

extension LoginVC {
    
    func checkIfKakaoInstalled() {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    if let tokenString = oauthToken?.accessToken {
                        Config.accessToken = tokenString
                        let kakaoLoginRequest = SocialLoginRequest(socialPlatform: "kakao")
                        self.kakaoLogin(param: kakaoLoginRequest)
                    }
                }
            }
        } else {
            loginKakaoAccount()
        }
    }
    
    func loginKakaoAccount() {
        print("loginKakaoAccount() called.")
        
        // 웹 브라우저를 사용하여 로그인 진행
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                // 회원가입 성공 시 oauthToken 저장
                if let tokenString = oauthToken?.accessToken {
                    Config.accessToken = tokenString
                    let kakaoLoginRequest = SocialLoginRequest(socialPlatform: "kakao")
                    self.kakaoLogin(param: kakaoLoginRequest)
                }
            }
        }
    }
}

extension LoginVC {
    private func appleLogin(param: SocialLoginRequest) {
        AuthAPI.shared.getSocialLoginAPI(param: param) { response in
            if response?.success == true {
                // 회원가입뷰로 이동
            }
        }
    }
    
    private func kakaoLogin(param: SocialLoginRequest) {
        AuthAPI.shared.getSocialLoginAPI(param: param) { response in
            if response?.success == true {
                let signUpVC = SignUpVC()
                signUpVC.modalPresentationStyle = .fullScreen
                self.present(signUpVC, animated: true)
            }
        }
    }
}
