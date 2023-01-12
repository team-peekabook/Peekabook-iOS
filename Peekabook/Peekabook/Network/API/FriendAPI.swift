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
    
    // 1. 사용자 검색하기
    
    func searchUserData(nickname: String, completion: @escaping (GeneralResponse<SearchUserResponse>?) -> Void) {
        friendProvider.request(.getuser(nickname: nickname)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.searchUserData = try response.map(GeneralResponse<SearchUserResponse>.self)
                    completion(searchUserData)
                } catch let error {
                    print("error")
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
                    print("error")
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
