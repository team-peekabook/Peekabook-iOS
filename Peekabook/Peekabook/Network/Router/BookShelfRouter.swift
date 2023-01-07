//
//  BookShelfRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import Foundation

import Moya

enum BookShelfRouter {
    case getMyBookShelf
}

extension BookShelfRouter: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMyBookShelf:
            return URLConstant.bookShelf
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyBookShelf:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyBookShelf:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
