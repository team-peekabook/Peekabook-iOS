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
    case watchBookDetail(bookId: Int)
    case getFriendBookShelf(friendId: Int)
    case deleteBook(bookId: Int)
    case postMyBook(param: PostBookRequest)
}

extension BookShelfRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMyBookShelf:
            return URLConstant.bookShelf
        case .watchBookDetail(let bookId):
            return "\(URLConstant.detail)/\(bookId)"
        case .getFriendBookShelf(let friendId):
            return URLConstant.bookShelf + "/friend/\(friendId)"
        case .deleteBook(let bookId):
            return "\(URLConstant.bookShelf)/\(bookId)"
        case .postMyBook:
            return URLConstant.bookShelf
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf:
            return .get
        case .watchBookDetail:
            return .get
        case .deleteBook:
            return .delete
        case .postMyBook:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf:
            return .requestPlain
        case .watchBookDetail(let bookId):
            return .requestParameters(parameters: ["bookId": bookId], encoding: URLEncoding.queryString)
        case .getFriendBookShelf(let friendId):
            return .requestParameters(parameters: ["friendId": friendId], encoding: URLEncoding.queryString)
        case .deleteBook(let bookId):
            return .requestParameters(parameters: ["bookId": bookId], encoding: URLEncoding.queryString)
        case .postMyBook(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
