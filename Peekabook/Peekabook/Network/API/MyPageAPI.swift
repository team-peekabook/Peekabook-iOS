//
//  MyPageAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import UIKit

import Moya

final class MyPageAPI {
    
    private var mypageProvider: MoyaProvider<MyPageRouter>
    
    init(viewController: UIViewController) {
        mypageProvider = MoyaProvider<MyPageRouter>(plugins: [MoyaPlugin(viewController: viewController)])
    }
    
    // 1. 회원 탈퇴하기
    func deleteAccount(completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        mypageProvider.request(.deleteAccount) { result in
            switch result {
            case .success(let response):
                do {
                    let deleteAccountData = try response.map(GeneralResponse<BlankData>.self)
                    completion(deleteAccountData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 사용자 정보 조회하기
    func getMyAccountInfo(completion: @escaping (GeneralResponse<GetAccountResponse>?) -> Void) {
        mypageProvider.request(.getMyAccount) { result in
            switch result {
            case .success(let response):
                do {
                    let getAccountData = try response.map(GeneralResponse<GetAccountResponse>.self)
                    completion(getAccountData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 3. 차단된 사용자 리스트 조회하기
    func getBlockedAccountList(completion: @escaping (GeneralResponse<[GetBlockedAccountResponse]>?) -> Void) {
        mypageProvider.request(.getBlockedAccounts) { result in
            switch result {
            case .success(let response):
                do {
                    let blockedAccountsData = try response.map(GeneralResponse<[GetBlockedAccountResponse]>.self)
                    completion(blockedAccountsData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 4. 차단된 사용자 차단 해제하기
    func unblockAccount(userId: Int, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        mypageProvider.request(.unblockAccount(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let unblockAccount = try response.map(GeneralResponse<BlankData>.self)
                    completion(unblockAccount)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 5. 프로필 수정하기
    func editMyProfile(request: PatchProfileRequest, image: UIImage?, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        mypageProvider.request(.patchMyProfile(request: request, Image: image)) { result in
            switch result {
            case .success(let response):
                do {
                    let fetchProfileResponse = try response.map(GeneralResponse<BlankData>.self)
                    completion(fetchProfileResponse)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
