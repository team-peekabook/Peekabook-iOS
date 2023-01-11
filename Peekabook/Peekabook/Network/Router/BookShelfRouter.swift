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
    case getFriendBookShelf(friendId: Int)
}

extension BookShelfRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMyBookShelf:
            return URLConstant.bookShelf
        case .getFriendBookShelf(let friendId):
            return URLConstant.bookShelf + "/friend/\(friendId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf:
            return .requestPlain
//        case .getFriendBookShelf(let friendId):
//            return .requestParameters(parameters: ["friendId": friendId], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.defaultHeader
    }
}
