//
//  NaverSearchRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation

import Moya

enum NaverSearchRouter {
    case getBook(d_titl: String, d_isbn: String, display: Int)
}

extension NaverSearchRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.naverBookSearchURL)!
    }
    
    var path: String {
        switch self {
        case .getBook:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBook:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getBook(let d_titl, let d_isbn, let display):
            return .requestParameters(parameters: ["d_titl" : d_titl, "d_isbn": d_isbn, "display": display], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json", "X-Naver-Client-Id": "eKY2qrJCDXKrrBYCQbik", "X-Naver-Client-Secret": "gBiWl3YgAS"]
    }
}
