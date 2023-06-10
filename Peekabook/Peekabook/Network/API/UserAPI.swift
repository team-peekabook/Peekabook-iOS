//
//  UserAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import UIKit

import Moya

final class UserAPI {
    
    static let shared = UserAPI()
    private var userProvider = MoyaProvider<UserRouter>(plugins: [MoyaPlugin()])
    
    private init() { }
    
    private(set) var signUpData: GeneralResponse<BlankData>?
    private(set) var checkDuplicateData: GeneralResponse<CheckDuplicateResponse>?
    
    // 1. 회원 가입하기
    
    func signUp(param: SignUpRequest, image: UIImage, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        userProvider.request(.patchSignUp(param: param, image: image)) { [self] (result) in
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
    
    func checkDuplicate(param: CheckDuplicateRequest, completion: @escaping (GeneralResponse<CheckDuplicateResponse>?) -> Void) {
        userProvider.request(.checkDuplicate(param: param)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.checkDuplicateData = try response.map(GeneralResponse<CheckDuplicateResponse>.self)
                    completion(checkDuplicateData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
            
        }
    }
}
