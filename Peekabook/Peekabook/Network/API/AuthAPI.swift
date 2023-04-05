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
    
    private(set) var socialLoginData: GeneralResponse<SocialLoginRequest>?
    
    // 1. 소셜 로그인 API
    
    func getSocialLoginAPI(param: SocialLoginRequest, completion: @escaping (GeneralResponse<SocialLoginRequest>?) -> Void) {
        authProvider.request(.socialLogin(param: param)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.socialLoginData = try response.map(GeneralResponse<SocialLoginRequest>.self)
                    completion(socialLoginData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
