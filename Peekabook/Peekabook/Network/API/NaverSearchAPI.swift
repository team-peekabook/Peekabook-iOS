//
//  NaverSearchAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import UIKit

import Moya

final class NaverSearchAPI {
    
    private var naverSearchProvider = Providers.naverSearchProvider
                
    init(viewController: UIViewController) {
        naverSearchProvider = MoyaProvider<NaverSearchRouter>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    // 1. 네이버 책 검색
    func getNaverSearchedBooks(d_titl: String, d_isbn: String, display: Int, completion: @escaping ([BookInfoModel]?) -> Void) {
        naverSearchProvider.request(.getBook(d_titl: d_titl, d_isbn: d_isbn, display: display)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(NaverResponse.self)
                    let getNaverData: [BookInfoModel]? = response.items
                    completion(getNaverData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
