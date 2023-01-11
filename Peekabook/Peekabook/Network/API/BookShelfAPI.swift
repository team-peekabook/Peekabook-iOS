//
//  BookShelfAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation

import Moya

final class BookShelfAPI {
    
    static let shared = BookShelfAPI()
    private var bookShelfProvider = MoyaProvider<BookShelfRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var myBookShelfData: GeneralResponse<MyBookShelfResponse>?
    private(set) var friendBookShelfData: GeneralResponse<FriendBookShelfResponse>?
    
    // 1. 내 책장 (메인 뷰) 조회 하기
    
    func getMyBookShelfInfo(completion: @escaping (GeneralResponse<MyBookShelfResponse>?) -> Void) {
        bookShelfProvider.request(.getMyBookShelf) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.myBookShelfData = try response.map(GeneralResponse<MyBookShelfResponse>.self)
                    completion(myBookShelfData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 친구 책장 조회 하기
    
    func getFriendBookShelfInfo(friendId: Int, completion: @escaping (GeneralResponse<FriendBookShelfResponse>?) -> Void) {
        bookShelfProvider.request(.getFriendBookShelf(friendId: friendId)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.friendBookShelfData = try response.map(GeneralResponse<FriendBookShelfResponse>.self)
                    completion(friendBookShelfData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
