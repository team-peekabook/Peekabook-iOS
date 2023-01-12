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
    case watchBookDetail(bookId: Int)
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
        case .watchBookDetail(let bookId):
            return "\(URLConstant.detail)/\(bookId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf, .watchBookDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf, .watchBookDetail:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
