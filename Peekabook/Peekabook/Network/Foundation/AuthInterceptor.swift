//
//  AuthInterceptor.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/13.
//

import Foundation

import Alamofire
import Moya

// 토큰 만료 시 자동으로 refresh를 위한 서버 통신 But, 얘가 지금 적용이 안되고 있음
final class AuthInterceptor: RequestInterceptor {

    static let shared = AuthInterceptor()

    private init() { }

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(Config.baseURL) == true,
              let accessToken = UserManager.shared.accessToken,
              let refreshToken = UserManager.shared.refreshToken
        else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "accessToken")
        urlRequest.setValue(refreshToken, forHTTPHeaderField: "refreshToken")
        print("adator 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }

//    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        print("retry 진입")
//        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
//        else {
//            completion(.doNotRetryWithError(error))
//            return
//        }
//
//        UserManager.shared.getUpdatedTokenAPI { result in
//            switch result {
//            case .success:
//                print("여기는 AUTH INTERCEPTOR Retry-토큰 재발급 성공")
//                completion(.retry)
//            case .failure(let error):
//                print("여기는 AUTH INTERCEPTOR 세션 만료 -> 로그인 화면으로 전환 ")
//                UserManager.shared.logout()
//                completion(.doNotRetryWithError(error))
//            }
//        }
//    }
}
