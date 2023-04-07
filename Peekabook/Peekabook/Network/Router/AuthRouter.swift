//
//  AuthRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

enum AuthRouter {
    case socialLogin(param: SocialLoginRequest)
}

extension AuthRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .socialLogin:
            return URLConstant.auth + "/signin"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .socialLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .socialLogin(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.socialTokenHeader
    }
}
