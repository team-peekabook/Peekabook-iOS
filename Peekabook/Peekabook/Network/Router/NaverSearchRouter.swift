//
//  NaverSearchRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation

import Moya

enum NaverSearchRouter {
    case getBook(query: String, d_isbn: String, display: Int)
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
        case .getBook(let query, let d_isbn, let display):
            return .requestParameters(parameters: ["query": query, "d_isbn": d_isbn, "display": display], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json", "X-Naver-Client-Id": Config.naverClientId, "X-Naver-Client-Secret": Config.naverClientSecret]
    }
}
