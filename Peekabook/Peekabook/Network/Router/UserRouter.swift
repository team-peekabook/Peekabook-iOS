//
//  UserRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import UIKit

import Moya

enum UserRouter {
    case patchSignUp(param: SignUpRequest, image: UIImage)
    case checkDuplicate(param: CheckDuplicateRequest)
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchSignUp:
            return .patch
        case .checkDuplicate:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .patchSignUp(let param, let image):
            
            let imageData = image.pngData() ?? Data()
            let nicknameData = param.nickname.data(using: String.Encoding.utf8) ?? Data()
            let introData = param.intro.data(using: String.Encoding.utf8) ?? Data()

            let imageMultipartFormData = MultipartFormData(provider: .data(imageData), name: "file", fileName: ".jpeg", mimeType: "image/jpeg")
            let nicknameMultipartFormData = MultipartFormData(provider: .data(nicknameData), name: "nickname")
            let introMultipartFormData = MultipartFormData(provider: .data(introData), name: "intro")

            return .uploadMultipart([imageMultipartFormData, nicknameMultipartFormData, introMultipartFormData])
            
        case .checkDuplicate(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .patchSignUp:
            return NetworkConstant.multipartWithTokenHeader
        case .checkDuplicate:
            return NetworkConstant.hasTokenHeader
        }
    }
}
