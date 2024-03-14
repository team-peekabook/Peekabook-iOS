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
    case deleteRecommend(recommendID: Int)
}

extension RecommendRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getRecommend:
            return URLConstant.recommend
        case .deleteRecommend(let recommendId):
            return "\(URLConstant.recommend)/\(recommendId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecommend:
            return .get
        case .deleteRecommend:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRecommend:
            return .requestPlain
        case .deleteRecommend:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
