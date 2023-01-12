//
//  PickAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

final class PickAPI {
    
    static let shared = PickAPI()
    private var pickProvider = MoyaProvider<PickRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var picksData: GeneralResponse<[PickAllResponse]>?
    
    // 1. Pick 수정뷰에서 책 전체 조회하기
    
    func getAllPicks(completion: @escaping (GeneralResponse<[PickAllResponse]>?) -> Void) {
        pickProvider.request(.getPickAll) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.picksData = try response.map(GeneralResponse<[PickAllResponse]>.self)
                    completion(picksData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
}
