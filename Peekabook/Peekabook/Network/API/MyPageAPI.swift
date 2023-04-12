//
//  MyPageAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

final class MyPageAPI {
    
    static let shared = MyPageAPI()
    private var mypageProvider = MoyaProvider<MyPageRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var deleteAccountData: GeneralResponse<BlankData>?
    private(set) var getAccountData: GeneralResponse<BlankData>?
    
    // 1. 회원 탈퇴하기
    
    func deleteAccount(completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        mypageProvider.request(.deleteAccount) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.deleteAccountData = try response.map(GeneralResponse<BlankData>.self)
                    completion(deleteAccountData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getMyAccount(completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        mypageProvider.request(.getMyAccount) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.getAccountData = try response.map(GeneralResponse<BlankData>.self)
                    completion(getAccountData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
