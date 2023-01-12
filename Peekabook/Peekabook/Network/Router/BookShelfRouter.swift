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
    case watchBookDetail(bookId: Int)
=======
    case getFriendBookShelf(friendId: Int)
>>>>>>> 4855c87dc98997d24a3da222a1b5f6c3a9e75bed
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
        case .deleteBook(let bookId):
            return "\(URLConstant.bookShelf)/\(bookId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf, .watchBookDetail:
            return .get
        case .deleteBook:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getMyBookShelf, .getFriendBookShelf, .watchBookDetail, .deleteBook:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
