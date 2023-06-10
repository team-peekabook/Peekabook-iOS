//
//  AuthAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import UIKit

import Moya

final class AuthAPI {
    
    private var authProvider: MoyaProvider<AuthRouter>
    
    init(viewController: UIViewController? = nil) {
        authProvider = MoyaProvider<AuthRouter>(plugins: [MoyaPlugin(viewController: viewController)])
    }
    
    // 1. 소셜 로그인 API
    func getSocialLoginAPI(param: SocialLoginRequest, completion: @escaping (GeneralResponse<SocialLoginResponse>?) -> Void) {
        authProvider.request(.socialLogin(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let socialLoginData = try response.map(GeneralResponse<SocialLoginResponse>.self)
                    completion(socialLoginData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 토큰 재발급 API
    func getUpdatedTokenAPI(completion: @escaping (GeneralResponse<GetUpdatedTokenResponse>?) -> Void) {
        authProvider.request(.getUpdatedToken) { result in
            switch result {
            case .success(let response):
                do {
                    let getUpdatedTokenData = try response.map(GeneralResponse<GetUpdatedTokenResponse>.self)
                    completion(getUpdatedTokenData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
}
