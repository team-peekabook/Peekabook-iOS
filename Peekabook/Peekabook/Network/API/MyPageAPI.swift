//
//  MyPageAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import UIKit

import Moya

final class MyPageAPI {
    
    static let shared = MyPageAPI()
    private var mypageProvider = MoyaProvider<MyPageRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var deleteAccountData: GeneralResponse<BlankData>?
    private(set) var getAccountData: GeneralResponse<GetAccountResponse>?
    private(set) var blockedAccountsData: GeneralResponse<[GetBlockedAccountResponse]>?
    private(set) var unblockAccount: GeneralResponse<BlankData>?
    private(set) var fetchProfileResponse: GeneralResponse<BlankData>?
    
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
    
    // 2. 사용자 정보 조회하기
    func getMyAccountInfo(completion: @escaping (GeneralResponse<GetAccountResponse>?) -> Void) {
        mypageProvider.request(.getMyAccount) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.getAccountData = try response.map(GeneralResponse<GetAccountResponse>.self)
                    completion(getAccountData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 3. 차단된 사용자 리스트 조회하기
    func getBlockedAccountList(completion: @escaping (GeneralResponse<[GetBlockedAccountResponse]>?) -> Void) {
        mypageProvider.request(.getBlockedAccounts) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.blockedAccountsData = try response.map(GeneralResponse<[GetBlockedAccountResponse]>.self)
                    completion(blockedAccountsData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 4. 차단된 사용자 차단 해제하기
    func unblockAccount(userId: Int, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        mypageProvider.request(.unblockAccount(userId: userId)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.unblockAccount = try response.map(GeneralResponse<BlankData>.self)
                    completion(unblockAccount)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 5. 프로필 수정하기
    func editMyProfile(request: PatchProfileRequest, image: UIImage?, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        mypageProvider.request(.patchMyProfile(request: request, Image: image)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.fetchProfileResponse = try response.map(GeneralResponse<BlankData>.self)
                    completion(fetchProfileResponse)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
