//
//  RecommendRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

enum RecommendRouter {
    case getRecommend
}

extension RecommendRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getRecommend:
            return URLConstant.recommend
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecommend:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRecommend:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasUserIdHeader
    }
}
