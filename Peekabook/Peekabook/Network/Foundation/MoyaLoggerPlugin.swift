//
//  MoyaLoggerPlugin.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/07.
//

import UIKit

import Moya

final class MoyaLoggerPlugin: PluginType {
    
    // MARK: - Properties
    
    private let viewController: UIViewController?
    
    // MARK: - Initialization
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

// MARK: - Methods

extension MoyaLoggerPlugin {
    
    // Request를 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("--> 유효하지 않은 요청")
            return
        }
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        var log = "----------------------------------------------------\n1️⃣[\(method)] \(url)\n----------------------------------------------------\n"
        log.append("2️⃣API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("header: \(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
            log.append("\(bodyString)\n")
        }
        log.append("------------------- END \(method) -------------------")
        print(log)
    }
    
    // Response가 왔을 때
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSuceed(response, target: target)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
    
    func onSuceed(_ response: Response, target: TargetType) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        var log = "------------------- 네트워크 통신 성공했는가? -------------------"
        log.append("\n3️⃣[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("response: \n")
        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
            log.append("4️⃣\(reString)\n")
        }
        log.append("------------------- END HTTP -------------------")
        print(log)
        
        // 🔥 토큰 갱신 서버통신 메서드.
        switch statusCode {
        case 401:
            print("-----------🤷🏻‍♀️401 401🤷🏻‍♀️-----------")
            userTokenReissueWithAPI(target: target)
        default:
            return
        }
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuceed(response, target: target)
            return
        }
        var log = "네트워크 오류"
        log.append("<-- \(error.errorCode)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP")
        print(log)
        
        // 네트워크 연결 유실 시 팝업 띄움
        let alertVC = NetworkAlertPopUpVC()
        alertVC.modalPresentationStyle = .fullScreen
        viewController?.present(alertVC, animated: false)
    }
    
    // 이전에 수행하던 서버 통신을 다시 호출
    func retryPreviousRequest(target: TargetType) {
        let provider = MoyaProvider<MultiTarget>(plugins: [MoyaLoggerPlugin(viewController: nil)])
        let multiTarget = MultiTarget(target)
        
        provider.request(multiTarget) { result in
            switch result {
            case let .success(response):
                // 서버 통신 성공 시 처리
                self.onSuceed(response, target: target)
            case let .failure(error):
                // 서버 통신 실패 시 처리
                self.onFail(error, target: target)
            }
        }
    }
}

extension MoyaLoggerPlugin {
//
    func userTokenReissueWithAPI(target: TargetType? = nil) {
        UserManager.shared.getUpdatedTokenAPI { response in
            print("✨ accessToken 재발급 이전 \(UserDefaults.standard.string(forKey: "accessToken") ?? "")")
            print("✨ refreshToken 재발급 이전 \(UserDefaults.standard.string(forKey: "refreshToken") ?? "")")
            if let response = response, let message = response.message {

                if response.success == true {
                    if let data = response.data {
                        UserManager.shared.accessToken = data.newAccessToken
                        UserManager.shared.refreshToken = data.refreshToken

                        print("🥹 accessToken 토큰 재발급 성공: \(UserDefaults.standard.string(forKey: "accessToken") ?? "")")
                        print("🥹 refreshToken 토큰: \(UserDefaults.standard.string(forKey: "refreshToken") ?? "")")

                        // 토큰 재발급 성공시 이전 요청을 재실행
                        guard let target else { return }
                        self.retryPreviousRequest(target: target)
                    }
                } else if message == "모든 토큰이 만료되었습니다. 재로그인 해주세요." || message == "잘못된 요청입니다." {
                    UserManager.shared.logout()

                    let loginVC = LoginVC()
                    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                    window?.rootViewController = loginVC
                }
            }
        }
    }
}
