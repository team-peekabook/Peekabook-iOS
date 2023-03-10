//
//  NaverSearchAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

final class NaverSearchAPI {
    
    static var shared = NaverSearchAPI()
    private var naverSearchProvider = MoyaProvider<NaverSearchRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    // 네이버 책검색 API 불러오기
    
    func getNaverSearchedBooks(d_titl: String, d_isbn: String, display: Int, completion: @escaping ([BookInfoModel]?) -> Void) {
        naverSearchProvider.request(.getBook(d_titl: d_titl, d_isbn: d_isbn, display: display)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(NaverResponse.self)
                    let getNaverData: [BookInfoModel] = response.items
                    completion(getNaverData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
