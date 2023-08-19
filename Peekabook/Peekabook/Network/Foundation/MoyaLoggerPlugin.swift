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
    
    private var isRefreshed: Bool = false {
        didSet {
            if isRefreshed {
                userTokenReissueWithAPI()
            }
        }
    }
    
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
        
        // 🔥 401 인 경우 리프레쉬 토큰 + 액세스 토큰 을 가지고 갱신 시도.
        switch statusCode {
        case 401:
            // 🔥 토큰 갱신 서버통신 메서드.
            print("-----------🤷🏻‍♀️401 401🤷🏻‍♀️-----------")
            userTokenReissueWithAPI()
//            UserManager.shared.getUpdatedTokenAPI { result in
//                switch result {
//                case .success:
//                    print("여기는 MOYA LOGGER PLUGIN Retry-토큰 재발급 성공")
//                    // 이전에 수행하던 서버 통신을 다시 호출
//                    self.retryPreviousRequest(target: target)
//                case .failure:
//                    print("여기는 MOYA LOGGER PLUGIN 세션 만료 -> 로그인 화면으로 전환")
//                    UserManager.shared.logout()
//                    let loginVC = LoginVC()
//                    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
//                    window?.rootViewController = loginVC
//                }
//            }
        default:
            return
        }
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            //            onSuceed(response, target: target)
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

    func userTokenReissueWithAPI() {
        UserManager.shared.getUpdatedTokenAPI { response in
//            print("🌟요청하기 전 socialToken\(UserDefaults.standard.string(forKey: "socialToken"))")
//            print("🌟요청하기 전 accessToken\(UserDefaults.standard.string(forKey: "accessToken"))")
//            print("🌟요청하기 전 refreshToken\(UserDefaults.standard.string(forKey: "refreshToken"))")

            switch response {
            case .success:
                print("✅ 토큰 재발급 성공 ")
                // 🔥 성공적으로 액세스 토큰, 리프레쉬 토큰 갱신.
//                UserDefaults.standard.setValue(data.newAccessToken, forKey: "accessToken")
//                UserDefaults.standard.setValue(data.refreshToken, forKey: "refreshToken")
//                print("✅✅✅토큰 재발급 성공✅✅✅ socialToken\(UserDefaults.standard.string(forKey: "socialToken"))")
//                print("✅✅✅토큰 재발급 성공✅✅✅ accessToken\(UserDefaults.standard.string(forKey: "accessToken"))")
//                print("✅✅✅토큰 재발급 성공✅✅✅ refreshToken\(UserDefaults.standard.string(forKey: "refreshToken"))")
            case .failure(let error):
                print("😢 userTokenReissueWithAPI failure", error.localizedDescription)
                UserManager.shared.logout()
                let loginVC = LoginVC()
                let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                window?.rootViewController = loginVC
            }
            
//            else if response == "모든 토큰이 만료되었습니다. 재로그인 해주세요." || message == "잘못된 요청입니다." {
//                    print("🍄🍄 모든 토큰이 만료된 경우 or 유효하지 않은 유저의 리프레시 토큰으로 요청 🍄🍄🍄")
//                    UserDefaults.standard.removeObject(forKey: "accessToken")
//                    UserDefaults.standard.removeObject(forKey: "refreshToken")
//                    UserDefaults.standard.removeObject(forKey: "socialToken")
//
//                    let loginVC = LoginVC()
//                    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
//                    window?.rootViewController = loginVC
//
//                } else if message == "토큰이 유효합니다" {
//                    print("✅✅✅ 토큰이 유효함 !!!! ✅✅✅")
//                } else if message == "토큰 값이 없습니다." {
//                    print("✅✅✅ 노노토큰.. ✅✅✅")
//                } else if message == "유효하지 않은 리프레시 토큰입니다." {
//                    print("✅✅✅ 유효하지 않은 리프레시 토큰 ✅✅✅")
//                }
//            }
        }
    }
}
