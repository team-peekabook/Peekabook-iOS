//
//  BookShelfAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import UIKit

import Moya

final class BookShelfAPI {
    
    private var bookShelfProvider = MoyaProvider<BookShelfRouter>(plugins: [MoyaLoggerPlugin(viewController: nil)])
    
    init(viewController: UIViewController) {
        bookShelfProvider = MoyaProvider<BookShelfRouter>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    // 1. 내 책장 (메인 뷰) 조회 하기
    func getMyBookShelfInfo(completion: @escaping (GeneralResponse<MyBookShelfResponse>?) -> Void) {
        bookShelfProvider.request(.getMyBookShelf) { result in
            switch result {
            case .success(let response):
                do {
                    let myBookShelfData = try response.map(GeneralResponse<MyBookShelfResponse>.self)
                    completion(myBookShelfData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 친구 책장 조회 하기
    func getFriendBookShelfInfo(friendId: Int, completion: @escaping (GeneralResponse<FriendBookShelfResponse>?) -> Void) {
        bookShelfProvider.request(.getFriendBookShelf(friendId: friendId)) { result in
            switch result {
            case .success(let response):
                do {
                    let friendBookShelfData = try response.map(GeneralResponse<FriendBookShelfResponse>.self)
                    completion(friendBookShelfData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 3. 등록한 책 상세 정보 불러오기
    func getBookDetail(id: Int, completion: @escaping (GeneralResponse<WatchBookDetailResponse>?) -> Void) {
        bookShelfProvider.request(.watchBookDetail(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let watchBookDetailData = try response.map(GeneralResponse<WatchBookDetailResponse>.self)
                    completion(watchBookDetailData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }

    // 4. 책장에서 책 삭제하기
    func deleteBook(bookId: Int, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        bookShelfProvider.request(.deleteBook(bookId: bookId)) { result in
            switch result {
            case .success(let response):
                do {
                    let deleteBookData = try response.map(GeneralResponse<BlankData>.self)
                    completion(deleteBookData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 5. 내 책장에 책 등록하기
    func postMyBookInfo(param: PostBookRequest, completion: @escaping (GeneralResponse<PostBookRequest>?) -> Void) {
        bookShelfProvider.request(.postMyBook(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let addBookData = try response.map(GeneralResponse<PostBookRequest>.self)
                    completion(addBookData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 6. 내 책장에 등록한 책 정보 수정하기
    func editMyBookInfo(id: Int, param: EditBookRequest, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        bookShelfProvider.request(.editBookInfo(id: id, param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let editBookData = try response.map(GeneralResponse<BlankData>.self)
                    completion(editBookData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 7. 등록된 책 중복검사
    func checkBookDuplicate(param: CheckBookDuplicateRequest, completion: @escaping (GeneralResponse<CheckBookDuplicateResponse>?) -> Void) {
        bookShelfProvider.request(.checkBookDuplicate(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let checkBookDuplicateData = try response.map(GeneralResponse<CheckBookDuplicateResponse>.self)
                    completion(checkBookDuplicateData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
            
        }
    }

}
