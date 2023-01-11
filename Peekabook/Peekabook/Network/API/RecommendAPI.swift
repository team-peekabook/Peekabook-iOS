//
//  RecommendAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

final class RecommendAPI {
    
    static let shared = RecommendAPI()
    private var recommendProvider = MoyaProvider<RecommendRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var getRecommendData: GeneralResponse<GetRecommendResponse>?
    
    // 1. 추천보기
    
    func getRecommend(completion: @escaping (GeneralResponse<GetRecommendResponse>?) -> Void) {
        recommendProvider.request(.getRecommend) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.getRecommendData = try response.map(GeneralResponse<GetRecommendResponse>.self)
                    completion(getRecommendData)
                } catch let error {
                    print("error")
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
