//
//  UserManager.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/13.
//

import Foundation

import Moya

enum ErrorType: LocalizedError {
    case networkFail
}

final class UserManager {
    
    static let shared = UserManager()
    
    private let authProvider = Providers.authProvider
    
    @UserDefaultWrapper<String>(key: "socialToken") var socialToken
    @UserDefaultWrapper<String>(key: "accessToken") var accessToken
    @UserDefaultWrapper<String>(key: "refreshToken") var refreshToken
    @UserDefaultWrapper<Bool>(key: "isKakao") var isKakao
    @UserDefaultWrapper<Bool>(key: "isSignUp") var isSignUp
    var hasAccessToken: Bool { return self.accessToken != nil && isSignUp == true }
    
    private init() { }

//    func updateToken(accessToken: String, refreshToken: String, isKakao: Bool) {
//        self.accessToken = accessToken
//        self.refreshToken = refreshToken
//        self.isKakao = isKakao
//    }
    
    // 1. 소셜 로그인
    func getSocialLoginAPI(param: SocialLoginRequest, completion: @escaping(Result<Bool, ErrorType>) -> Void) {
        authProvider.request(.socialLogin(param: param)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if 200..<300 ~= response.statusCode {
                    do {
                        let response = try response.map(GeneralResponse<SocialLoginResponse>.self)
                        guard let data = response.data else { return }
                        self.accessToken = data.accessToken
                        self.refreshToken = data.refreshToken
                        self.isSignUp = data.isSignedUp
                        completion(.success(data.isSignedUp)) // 로그인인지 회원가입인지 전달
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(.networkFail))
                    }
                } else {
                    print("getSocialLoginAPI statusCode ERROR")
                    completion(.failure(.networkFail))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(.networkFail))
            }
        }
    }
    
    // 2. 토큰 재발급
    func getUpdatedTokenAPI(completion: @escaping(Result<Bool, ErrorType>) -> Void) {
        authProvider.request(.getUpdatedToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if 200..<300 ~= response.statusCode {
                    do {
                        let response = try response.map(GeneralResponse<GetUpdatedTokenResponse>.self)
                        guard let data = response.data else { return }
                        self.accessToken = data.newAccessToken
                        self.refreshToken = data.refreshToken
                        completion(.success(true))
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(.networkFail))
                    }
                } else {
                    self.logout()
                    print("🚨 getUpdatedTokenAPI statusCode ERROR: ", response.statusCode)
                    completion(.failure(.networkFail))
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(.failure(.networkFail))
            }
        }
    }
    
    func logout() {
        self.resetTokens()
    }
    
    private func resetTokens() {
        self.socialToken = nil
        self.accessToken = nil
        self.refreshToken = nil
        self.isKakao = nil
        self.isSignUp = nil
    }
}
