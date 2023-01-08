//
//  RecommendRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

enum RecommendRouter {
    case sample
}

extension RecommendRouter: TargetType {
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .sample:
            return URLConstant.recommend
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
