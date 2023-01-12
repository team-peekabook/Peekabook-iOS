//
//  FriendRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation

import Moya

enum FriendRouter {
    case sample
    case getuser(nickname: String)
    case postFollowing(id: Int)
    case deleteFollowing(id: Int)
}

extension FriendRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sample:
            return URLConstant.friend
        case .getuser:
            return URLConstant.friend
        case .postFollowing(let id):
            return "\(URLConstant.friend)/\(id)"
        case .deleteFollowing(let id):
            return "\(URLConstant.friend)/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sample:
            return .get
        case .getuser:
            return .get
        case .postFollowing:
            return .post
        case .deleteFollowing:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sample:
            return .requestPlain
        case .getuser(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .postFollowing(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case .deleteFollowing(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
