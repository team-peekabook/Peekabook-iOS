//
//  AuthRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

enum AuthRouter {
    case appleLogin(param: AppleLoginRequest)
}

extension AuthRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .appleLogin:
            return URLConstant.auth + "/signin"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .appleLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .appleLogin(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
