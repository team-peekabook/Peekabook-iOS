//
//  AuthRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

enum AuthRouter {
    case sample
}

extension AuthRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sample:
            return URLConstant.auth
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sample:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .sample:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
