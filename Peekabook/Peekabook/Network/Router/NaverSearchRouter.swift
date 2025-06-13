//
//  NaverSearchRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation
import Moya

enum NaverSearchRouter {
    case getBook(query: String?, d_isbn: String?, display: Int)
}

extension NaverSearchRouter: TargetType {
    var baseURL: URL {
        // book.json (일반검색) 또는 book_adv.json (isbn검색)을 구분
        switch self {
        case let .getBook(_, d_isbn, _):
            if let isbn = d_isbn, !isbn.isEmpty {
                return URL(string: Config.naverBookSearchURLWithBarcode)!
            } else {
                return URL(string: Config.naverBookSearchURL)!
            }
        }
    }

    var path: String {
        return "" // 이미 baseURL에 전체 경로 포함
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        switch self {
        case let .getBook(query, d_isbn, display):
            var parameters: [String: String] = [:]
            parameters["display"] = "\(display)"

            if let isbn = d_isbn, !isbn.isEmpty {
                parameters["d_isbn"] = isbn
            } else if let q = query, !q.isEmpty {
                parameters["query"] = q
            }

            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "X-Naver-Client-Id": Config.naverClientId,
            "X-Naver-Client-Secret": Config.naverClientSecret
        ]
    }
}
