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
    // private(set) var postFollowing: GeneralResponse<
    
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
}
