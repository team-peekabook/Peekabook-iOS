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
    
    private(set) var appleLoginData: GeneralResponse<AppleLoginRequest>?
    
    // 1. 애플 로그인 API
    
    func getAppleLoginAPI(param: AppleLoginRequest, completion: @escaping (GeneralResponse<AppleLoginRequest>?) -> Void) {
        authProvider.request(.appleLogin(param: param)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.appleLoginData = try response.map(GeneralResponse<AppleLoginRequest>.self)
                    completion(appleLoginData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
