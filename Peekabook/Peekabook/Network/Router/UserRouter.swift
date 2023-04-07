//
//  UserRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

enum UserRouter {
    case patchSignUp(param: SignUpRequest)
}

extension UserRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .patchSignUp:
            return URLConstant.auth + "/signup"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchSignUp:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .patchSignUp(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
