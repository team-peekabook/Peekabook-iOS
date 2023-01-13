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
    
    private(set) var watchBookDetailData: GeneralResponse<WatchBookDetailResponse>?
    
    private(set) var deleteBookData: GeneralResponse<BlankData>?
    
    private (set) var addBookData: GeneralResponse<PostBookRequest>?
    
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
    
    // 3. 등록한 책 상세 정보 불러오기
    
    func getBookDetail(id: Int, completion: @escaping (GeneralResponse<WatchBookDetailResponse>?) -> Void) {
        bookShelfProvider.request(.watchBookDetail(id: id)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.watchBookDetailData = try response.map(GeneralResponse<WatchBookDetailResponse>.self)
                    completion(watchBookDetailData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
            print(err)
        }
        }
    }

    // 4. 책장에서 책 삭제하기
    
    func deleteBook(bookId: Int, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        bookShelfProvider.request(.deleteBook(bookId: bookId)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.deleteBookData = try response.map(GeneralResponse<BlankData>.self)
                    completion(deleteBookData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 5. 내 책장에 책 등록하기
    
    func postMyBookInfo(param: PostBookRequest, completion: @escaping (GeneralResponse<PostBookRequest>?) -> Void) {
        bookShelfProvider.request(.postMyBook(param: param)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.addBookData = try response.map(GeneralResponse<PostBookRequest>.self)
                    completion(addBookData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
