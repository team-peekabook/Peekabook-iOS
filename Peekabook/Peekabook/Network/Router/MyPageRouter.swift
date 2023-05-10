//
//  MyPageRouter.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import UIKit

import Moya

enum MyPageRouter {
    case deleteAccount
    case getMyAccount
    case getBlockedAccounts
    case unblockAccount(userId: Int)
    case patchMyProfile(request: PatchProfileRequest, Image: UIImage?)
}

extension MyPageRouter: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .deleteAccount:
            return URLConstant.mypage + "/withdraw"
        case .getMyAccount:
            return URLConstant.mypage + "/profile"
        case .getBlockedAccounts:
            return URLConstant.mypage + "/blocklist"
        case .unblockAccount(let userId):
            return URLConstant.mypage + "/blocklist/\(userId)"
        case .patchMyProfile:
            return URLConstant.mypage + "/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteAccount, .unblockAccount:
            return .delete
        case .getMyAccount, .getBlockedAccounts:
            return .get
        case .patchMyProfile:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .deleteAccount, .getMyAccount, .getBlockedAccounts, .unblockAccount:
            return .requestPlain
        case .patchMyProfile(let request, let image):
            let imageData = image?.pngData() ?? Data()
            let nicknameData = request.nickname.data(using: String.Encoding.utf8) ?? Data()
            let introData = request.intro.data(using: String.Encoding.utf8) ?? Data()

            let imageMultipartFormData = MultipartFormData(provider: .data(imageData), name: "file", fileName: ".jpeg", mimeType: "image/jpeg")
            let nicknameMultipartFormData = MultipartFormData(provider: .data(nicknameData), name: "nickname")
            let introMultipartFormData = MultipartFormData(provider: .data(introData), name: "intro")

            return .uploadMultipart([imageMultipartFormData, nicknameMultipartFormData, introMultipartFormData])
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .deleteAccount, .getMyAccount, .getBlockedAccounts, .unblockAccount:
            return NetworkConstant.hasTokenHeader
        case .patchMyProfile:
            return NetworkConstant.multipartWithTokenHeader
        }
    }
}
