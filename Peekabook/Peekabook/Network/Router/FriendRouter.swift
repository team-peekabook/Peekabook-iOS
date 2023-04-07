//
//  FriendRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation

import Moya

enum FriendRouter {
    case getUser(nickname: String)
    case postFollowing(id: Int)
    case deleteFollowing(id: Int)
    case postProposalBook(friendId: Int, param: ProposalBookRequest)
    case postUserReport(friendId: Int, param: UserReportRequest)
}

extension FriendRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUser:
            return URLConstant.friend
        case .postFollowing(let id):
            return "\(URLConstant.friend)/\(id)"
        case .deleteFollowing(let id):
            return "\(URLConstant.friend)/\(id)"
        case .postProposalBook(let friendId, _):
            return URLConstant.friend + "/\(friendId)" + "/recommend"
        case .postUserReport(let friendId, _):
            return URLConstant.friend + "/\(friendId)" + "/report"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        case .postFollowing, .postProposalBook, .postUserReport:
            return .post
        case .deleteFollowing:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUser(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .postFollowing, .deleteFollowing:
            return .requestPlain
        case .postProposalBook(_, let param):
            return .requestJSONEncodable(param)
        case .postUserReport(_, let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
