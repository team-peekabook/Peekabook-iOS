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
import SafariServices

final class LoginVC: UIViewController {

    // MARK: - UI Components
    
    private let logoImgView = UIImageView().then {
        $0.image = ImageLiterals.Image.appLogo
    }
    
    private lazy var kakaoLoginButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.kakaoButton, for: .normal)
        $0.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let appleButtonImageView = UIImageView().then {
        $0.image = ImageLiterals.Icn.appleButton
    }
    
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
        view.addSubviews(logoImgView, kakaoLoginButton, appleLoginButton, appleButtonImageView, infoLabel, labelContainerView)
        labelContainerView.addSubviews(serviceTermsLabel, andLabel, privacyPolicyLabel)
        
        logoImgView.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-190.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(44)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(infoLabel.snp.top).offset(-31)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(44)
        }
        
        appleButtonImageView.snp.makeConstraints {
            $0.bottom.centerX.width.height.equalTo(appleLoginButton)
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
    
    @objc
    private func kakaoLoginButtonDidTap() {
        print("카카오 로그인")
        kakaoLogin()
    }
    
    @objc
    private func appleLoginButtonDidTap() {
        print("애플 로그인")
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc
    private func moveTotermsAndpolicy() {
        let safariViewController = SFSafariViewController(url: URL(string: ExternalURL.Login.privacyPolicy)!)
        self.present(safariViewController, animated: true)
    }
    
    // MARK: - Methods
    
    private func addButtonTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(moveTotermsAndpolicy))
        labelContainerView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - 애플 OAuth 소셜 로그인

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
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authString = String(data: authorizationCode, encoding: .utf8),
               let tokenString = String(data: identityToken, encoding: .utf8) {
//                print("authorizationCode: \(authorizationCode)")
//                print("identityToken: \(identityToken)")
//                print("authString: \(authString)")
//                print("tokenString: \(tokenString)")
                UserDefaults.standard.setValue(tokenString, forKey: "socialToken")
            }
            print("페이스아이디로 애플 소셜 인증 성공")
            
            let appleLoginRequest = SocialLoginRequest(socialPlatform: "apple")
            socialLogin(param: appleLoginRequest)
            
        // 비밀번호로 로그인
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
//            print("username: \(username)")
//            print("password: \(password)")
            
            print("비밀번호로 애플 소셜 인증 성공, 근데 여기는 토큰을 뭐로 받아오는거지? 🤷🏻")

            let appleLoginRequest = SocialLoginRequest(socialPlatform: "apple")
            socialLogin(param: appleLoginRequest)
            
        default:
            break
        }
    }
    
    // 로그인 실패시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 소셜 인증하고 중간에 닫은 경우 ‼️")
        UserDefaults.standard.removeObject(forKey: "socialToken")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
    }
}

// MARK: - 카카오 OAuth 소셜 로그인

extension LoginVC {

    func kakaoLogin() {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 앱으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print("앱으로 카카오 소셜 인증하고 중간에 닫은 경우 ‼️", error)
                    UserDefaults.standard.removeObject(forKey: "socialToken")
                    UserDefaults.standard.removeObject(forKey: "accessToken")
                    UserDefaults.standard.removeObject(forKey: "refreshToken")
                } else {
                    print("앱으로 카카오 소셜 인증 성공")
                    UserDefaults.standard.setValue(oauthToken?.accessToken, forKey: "socialToken")

                    if let _ = oauthToken?.accessToken {
                        let kakaoLoginRequest = SocialLoginRequest(socialPlatform: "kakao")
                        self.socialLogin(param: kakaoLoginRequest)
                    }
                }
            }
        } else {
            // 웹 브라우저를 사용하여 로그인 진행
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print("웹으로 카카오 소셜 인증하고 중간에 닫은 경우 ‼️", error)
                    UserDefaults.standard.removeObject(forKey: "socialToken")
                    UserDefaults.standard.removeObject(forKey: "accessToken")
                    UserDefaults.standard.removeObject(forKey: "refreshToken")

                } else {
                    print("웹으로 카카오 소셜 인증 성공")
                    UserDefaults.standard.setValue(oauthToken?.accessToken, forKey: "socialToken")

                    if let _ = oauthToken?.accessToken {
                        let kakaoLoginRequest = SocialLoginRequest(socialPlatform: "kakao")
                        self.socialLogin(param: kakaoLoginRequest)
                    }
                }
            }
        }
    }
}

// MARK: - Network: 피카북 서버 소셜 로그인

extension LoginVC {
    func socialLogin(param: SocialLoginRequest) {
        AuthAPI.shared.getSocialLoginAPI(param: param) { response in
            if response?.success == true {
                if let data = response?.data {
                    UserDefaults.standard.setValue(data.accessToken, forKey: "accessToken")
                    UserDefaults.standard.setValue(data.refreshToken, forKey: "refreshToken")
                    self.changeNextViewController(isSigned: data.isSignedUp)
                    
                }
            }
        }
    }
    
    /// 이미 회원가입한 유저의 경우 소셜로그인 버튼을 누르고 회원가입 뷰가 아닌 바로 탭 뷰로 이동한다
    private func changeNextViewController(isSigned: Bool) {
        if isSigned {
            self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
        } else {
            let signUpVC = SignUpVC()
            signUpVC.modalPresentationStyle = .fullScreen
            self.present(signUpVC, animated: true, completion: nil)
            
        }
    }
}
