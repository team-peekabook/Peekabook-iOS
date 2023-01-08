//
//  PickRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

enum PickRouter {
    case sample
}

extension PickRouter: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sample:
            return URLConstant.pick
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
        return NetworkConstant.defaultHeader
    }
}
