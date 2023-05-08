//
//  AuthAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

final class AuthAPI {
    
    static let shared = AuthAPI()
    private var authProvider = MoyaProvider<AuthRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var socialLoginData: GeneralResponse<SocialLoginResponse>?
    private(set) var getUpdatedTokenData: GeneralResponse<GetUpdatedTokenResponse>?
    
    // 1. 소셜 로그인 API
    
    func getSocialLoginAPI(param: SocialLoginRequest, completion: @escaping (GeneralResponse<SocialLoginResponse>?) -> Void) {
        authProvider.request(.socialLogin(param: param)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.socialLoginData = try response.map(GeneralResponse<SocialLoginResponse>.self)
                    completion(socialLoginData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 토큰 재발급 API
    
    func getUpdatedTokenAPI(completion: @escaping (GeneralResponse<GetUpdatedTokenResponse>?) -> Void) {
        authProvider.request(.getUpdatedToken) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.getUpdatedTokenData = try response.map(GeneralResponse<GetUpdatedTokenResponse>.self)
                    completion(getUpdatedTokenData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
}
