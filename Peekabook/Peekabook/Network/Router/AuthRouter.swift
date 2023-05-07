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
    case getUpdatedToken
}

extension AuthRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .socialLogin:
            return URLConstant.auth + "/signin"
        case .getUpdatedToken:
            return URLConstant.auth + "/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .socialLogin:
            return .post
        case .getUpdatedToken:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .socialLogin(let param):
            return .requestJSONEncodable(param)
        case .getUpdatedToken:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .socialLogin:
            return NetworkConstant.socialTokenHeader
        case .getUpdatedToken:
            return NetworkConstant.updateTokenHeader
        }
    }
}
