//
//  RecommendAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import UIKit

import Moya

final class RecommendAPI {
    
    private var recommendProvider = MoyaProvider<RecommendRouter>(plugins: [MoyaLoggerPlugin(viewController: nil)])
    
    init(viewController: UIViewController) {
        recommendProvider = MoyaProvider<RecommendRouter>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    // 1. 추천보기
    func getRecommend(completion: @escaping (GeneralResponse<GetRecommendResponse>?) -> Void) {
        recommendProvider.request(.getRecommend) { result in
            switch result {
            case .success(let response):
                do {
                    let getRecommendData = try response.map(GeneralResponse<GetRecommendResponse>.self)
                    completion(getRecommendData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. 추천삭제
    func deleteRecommend(recommendId: Int, completion: @escaping (GeneralResponse<BlankData>?) -> Void) {
        recommendProvider.request(.deleteRecommend(recommendID: recommendId)) { result in
            switch result {
            case .success(let response):
                do {
                    let deleteRecommendData = try response.map(GeneralResponse<BlankData>.self)
                    completion(deleteRecommendData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
}
