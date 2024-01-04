//
//  UserRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import UIKit

import Moya

enum UserRouter {
    case patchSignUp(param: SignUpRequest, image: UIImage?)
    case checkDuplicate(param: CheckDuplicateRequest)
    case checkVersion
}

extension UserRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .patchSignUp:
            return URLConstant.auth + "/signup"
        case .checkDuplicate:
            return URLConstant.user + "/duplicate"
        case .checkVersion:
            return URLConstant.user + "/v1/version"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchSignUp:
            return .patch
        case .checkDuplicate:
            return .post
        case .checkVersion:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .patchSignUp(let param, let image):
            let nicknameData = param.nickname.data(using: String.Encoding.utf8) ?? Data()
            let introData = param.intro.data(using: String.Encoding.utf8) ?? Data()
            
            let multipartData: [MultipartFormBodyPart]
            if let image = image, let imageData = image.pngData() {
                multipartData = [MultipartFormBodyPart(provider: .data(imageData), name: "file", fileName: ".jpeg", mimeType: "image/jpeg"),
                                 MultipartFormBodyPart(provider: .data(nicknameData), name: "nickname"),
                                 MultipartFormBodyPart(provider: .data(introData), name: "intro")]
            } else {
                multipartData = [MultipartFormBodyPart(provider: .data(nicknameData), name: "nickname"),
                                 MultipartFormBodyPart(provider: .data(introData), name: "intro")]
            }
            
            return .uploadMultipart(multipartData)
        case .checkDuplicate(let param):
            return .requestJSONEncodable(param)
        case .checkVersion:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .patchSignUp:
            return NetworkConstant.multipartWithTokenHeader
        case .checkDuplicate, .checkVersion:
            return NetworkConstant.hasTokenHeader
        }
    }
}
