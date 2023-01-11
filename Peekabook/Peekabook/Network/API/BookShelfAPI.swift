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
    
    private(set) var watchBookDetailData: GeneralResponse<WatchBookDetailResponse>?
    
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
    
    // 2. 등록한 책 상세 정보 불러오기
    
    func getBookDetail(bookId: Int, completion: @escaping (GeneralResponse<WatchBookDetailResponse>?) -> Void) {
        bookShelfProvider.request(.watchBookDetail(bookId: bookId)) { [self] (result) in
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
}
