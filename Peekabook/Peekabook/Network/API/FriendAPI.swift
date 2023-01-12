//
//  FriendAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

final class FriendAPI {
    
    static let shared = FriendAPI()
    private var friendProvider = MoyaProvider<FriendRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var searchUserData: GeneralResponse<SearchUserResponse>?
    private(set) var postFollowing: GeneralResponse<BlankData>?
    private(set) var deleteFollowing: GeneralResponse<BlankData>?
    
    // 1. 사용자 검색하기
    
    func searchUserData(nickname: String, completion: @escaping (GeneralResponse<SearchUserResponse>?) -> Void) {
        friendProvider.request(.getUser(nickname: nickname)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.searchUserData = try response.map(GeneralResponse<SearchUserResponse>.self)
                    completion(searchUserData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 친구 팔로우하기
    
    func postFollowing(id: Int, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        friendProvider.request(.postFollowing(id: id)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.postFollowing = try response.map(GeneralResponse<BlankData>.self)
                    completion(postFollowing)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 3. 친구 팔로우 취소하기
    
    func deleteFollowing(id: Int, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        friendProvider.request(.deleteFollowing(id: id)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.deleteFollowing = try response.map(GeneralResponse<BlankData>.self)
                    completion(deleteFollowing)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
