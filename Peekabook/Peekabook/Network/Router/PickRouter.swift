//
//  PickRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

enum PickRouter {
    case getPickAll
    case editPickList(param: EditPickRequest)
}

extension PickRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getPickAll:
            return URLConstant.pick + "/all"
        case .editPickList:
            return URLConstant.pick
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPickAll:
            return .get
        case .editPickList:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPickAll:
            return .requestPlain
        case .editPickList(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        return NetworkConstant.hasTokenHeader
    }
}
