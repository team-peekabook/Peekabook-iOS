//
//  NaverSearchAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import UIKit

import Moya

final class NaverSearchAPI {
    
    private var naverSearchProvider = MoyaProvider<NaverSearchRouter>(plugins: [MoyaLoggerPlugin(viewController: nil)])
    
    init(viewController: UIViewController) {
        naverSearchProvider = MoyaProvider<NaverSearchRouter>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    func getNaverSearchedBooks(query: String, d_isbn: String, display: Int, completion: @escaping ([BookInfoModel]?) -> Void) {
        // query와 d_isbn 중 하나만 넘기도록 조정
        let queryParam = d_isbn.isEmpty ? query : nil
        let isbnParam = d_isbn.isEmpty ? nil : d_isbn

        naverSearchProvider.request(.getBook(query: queryParam, d_isbn: isbnParam, display: display)) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(NaverResponse.self)
                    completion(response.items)
                } catch let error {
                    print("📦 JSON 디코딩 실패: \(error.localizedDescription)")
                    completion(nil)
                }
            case .failure(let err):
                print("🌐 API 호출 실패: \(err)")
                completion(nil)
            }
        }
    }
}
