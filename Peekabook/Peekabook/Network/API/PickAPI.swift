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
    private(set) var editPicksData: GeneralResponse<[BlankData]>?

    
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
    
    // 2. Pick한 책 수정하기
    
    func patchPickList(param: EditPickRequest, completion: @escaping (GeneralResponse<[BlankData]>?) -> Void) {
        pickProvider.request(.getPickAll) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.editPicksData = try response.map(GeneralResponse<[BlankData]>.self)
                    completion(editPicksData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
