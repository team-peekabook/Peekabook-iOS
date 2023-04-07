//
//  UserAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

final class UserAPI {
    
    static let shared = UserAPI()
    private var userProvider = MoyaProvider<UserRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var signUpData: GeneralResponse<BlankData>?
    
    // 1. 회원 가입하기
    
    func signUp(param: SignUpRequest, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        userProvider.request(.patchSignUp(param: param)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.signUpData = try response.map(GeneralResponse<BlankData>.self)
                    completion(signUpData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
