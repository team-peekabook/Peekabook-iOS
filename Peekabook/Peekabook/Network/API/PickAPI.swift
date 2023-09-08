//
//  PickAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import UIKit

import Moya

final class PickAPI {

    private var pickProvider = MoyaProvider<PickRouter>(plugins: [MoyaLoggerPlugin(viewController: nil)])
    
    init(viewController: UIViewController) {
        pickProvider = MoyaProvider<PickRouter>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    // 1. Pick 수정뷰에서 책 전체 조회하기
    func getAllPicks(completion: @escaping (GeneralResponse<[PickAllResponse]>?) -> Void) {
        pickProvider.request(.getPickAll) { result in
            switch result {
            case .success(let response):
                do {
                    let picksData = try response.map(GeneralResponse<[PickAllResponse]>.self)
                    completion(picksData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    // 2. Pick한 책 수정하기
    func patchPickList(param: EditPickRequest, completion: @escaping (GeneralResponse<[BlankData]>?) -> Void) {
        pickProvider.request(.editPickList(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    let editPicksData = try response.map(GeneralResponse<[BlankData]>.self)
                    completion(editPicksData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
