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
    private var NaverSearchProvider = MoyaProvider<NaverSearchRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var NaverSearchData: GeneralResponse<[NaverSearchResponse]>?
    
    // 네이버 책검색 API 불러오기
    
    func getNaverSearchData(d_titl: String, d_isbn: String, display: Int, completion: @escaping (GeneralResponse<[NaverSearchResponse]>?) -> Void) {
        NaverSearchProvider.request(.getBook(d_titl: d_titl, d_isbn: d_isbn, display: display)) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    print("⚡️")
                    print(response)
                    print("✏️")
                    self.NaverSearchData = try response.map(GeneralResponse<[NaverSearchResponse]>.self)
                    print(NaverSearchData)
                    completion(NaverSearchData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
