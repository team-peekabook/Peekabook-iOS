//
//  MyPageRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

enum MyPageRouter {
    case deleteAccount
}

extension MyPageRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .deleteAccount:
            return URLConstant.mypage + "/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteAccount:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .deleteAccount:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
