//
//  UserAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import UIKit

import Moya

final class UserAPI {
    
    private var userProvider = MoyaProvider<UserRouter>(plugins: [MoyaLoggerPlugin(viewController: nil)])

    init(viewController: UIViewController) {
        userProvider = MoyaProvider<UserRouter>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    // 1. 회원 가입하기
    func signUp(param: SignUpRequest, image: UIImage?, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        userProvider.request(.patchSignUp(param: param, image: image)) { result in
            switch result {
            case .success(let response):
                do {
                    let signUpData = try response.map(GeneralResponse<BlankData>.self)
                    completion(signUpData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 닉네임 중복검사
    func checkDuplicate(param: CheckDuplicateRequest, completion: @escaping (GeneralResponse<CheckDuplicateResponse>?) -> Void) {
        userProvider.request(.checkDuplicate(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let checkDuplicateData = try response.map(GeneralResponse<CheckDuplicateResponse>.self)
                    completion(checkDuplicateData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
            
        }
    }
}
