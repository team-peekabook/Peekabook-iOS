//
//  AuthAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/28.
//

import Foundation

import Moya

final class AuthAPI {
    
    static let shared = AuthAPI()
    private var authProvider = MoyaProvider<AuthRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var sampleData: GeneralResponse<BlankData>?
    
    // 1. 샘플 API
    
    func getSampleAPI(completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        authProvider.request(.sample) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.sampleData = try response.map(GeneralResponse<BlankData>.self)
                    completion(sampleData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
