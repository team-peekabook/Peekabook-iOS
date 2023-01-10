//
//  FriendAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

final class FriendAPI {
    
    static let shared = FriendAPI()
    private var friendProvider = MoyaProvider<FriendRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    // 1. 내 책장 (메인 뷰) 조회 하기
    
    func searchUserNickname(nickname: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        friendProvider.request(.getuser(nickname: nickname)) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeUserSearchStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeUserSearchStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GeneralResponse<SearchUserResponse>.self, from: data)
        else {
            return .pathErr
        }
        
        switch statusCode {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400..<500:
            return .requestErr(decodedData.message as Any)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
