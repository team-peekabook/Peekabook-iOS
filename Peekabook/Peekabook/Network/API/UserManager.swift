//
//  UserManager.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/13.
//

import Foundation

import Moya

enum ErrorType: LocalizedError {
    case networkFail
}

final class UserManager {
    
    static let shared = UserManager()
    
    private var authProvider = MoyaProvider<AuthRouter>(plugins: [MoyaLoggerPlugin(viewController: nil)])
    
    private(set) var socialLoginData: GeneralResponse<SocialLoginResponse>?
    private(set) var getUpdatedTokenData: GeneralResponse<GetUpdatedTokenResponse>?

    @UserDefaultWrapper<String>(key: "socialToken") var socialToken
    @UserDefaultWrapper<String>(key: "accessToken") var accessToken
    @UserDefaultWrapper<String>(key: "refreshToken") var refreshToken
    @UserDefaultWrapper<Bool>(key: "isKakao") var isKakao
    @UserDefaultWrapper<Bool>(key: "isSignUp") var isSignUp
    var hasAccessToken: Bool { return self.accessToken != nil }
    
    private init() { }
    
    // 1. 소셜 로그인
    func getSocialLoginAPI(param: SocialLoginRequest, completion: @escaping (GeneralResponse<SocialLoginResponse>?) -> Void) {
        authProvider.request(.socialLogin(param: param)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.socialLoginData = try response.map(GeneralResponse<SocialLoginResponse>.self)
                    
                    self.accessToken = socialLoginData?.data?.accessToken
                    self.refreshToken = socialLoginData?.data?.refreshToken
                    self.isSignUp = socialLoginData?.data?.isSignedUp
                    
                    completion(socialLoginData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 토큰 재발급
    func getUpdatedTokenAPI(completion: @escaping (GeneralResponse<GetUpdatedTokenResponse>?) -> Void) {
        authProvider.request(.getUpdatedToken) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.getUpdatedTokenData = try response.map(GeneralResponse<GetUpdatedTokenResponse>.self)
                    
                    self.accessToken = getUpdatedTokenData?.data?.newAccessToken
                    self.refreshToken = getUpdatedTokenData?.data?.refreshToken
                    
                    completion(getUpdatedTokenData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func logout() {
        self.resetTokens()
    }
    
    private func resetTokens() {
        self.socialToken = nil
        self.accessToken = nil
        self.refreshToken = nil
        self.isKakao = nil
        self.isSignUp = nil
        UserDefaults.standard.clearCachedData()
    }
}
