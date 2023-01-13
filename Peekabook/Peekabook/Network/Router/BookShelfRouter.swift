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
    case deleteBook(bookId: Int)
    case watchBookDetail(id: Int)
    case postMyBook(param: PostBookRequest)
    case editBookInfo(id: Int, param: EditBookRequest)
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
        case .watchBookDetail(let id):
            return "\(URLConstant.detail)/\(id)"
        case .deleteBook(let bookId):
            return "\(URLConstant.bookShelf)/\(bookId)"
        case .postMyBook:
            return URLConstant.bookShelf
        case .editBookInfo(let bookId, _):
            return "\(URLConstant.bookShelf)/\(bookId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf, .watchBookDetail:
            return .get
        case .deleteBook:
            return .delete
        case .postMyBook:
            return .post
        case .editBookInfo:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf, .watchBookDetail, .deleteBook:
            return .requestPlain
        case .postMyBook(let param):
            return .requestJSONEncodable(param)
        case .editBookInfo(_, let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
