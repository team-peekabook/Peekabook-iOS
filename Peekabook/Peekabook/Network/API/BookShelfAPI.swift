//
//  BookShelfAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/08.
//

import Foundation

import Moya

final class BookShelfAPI {
    
    static let shared = BookShelfAPI()
    private var bookShelfProvider = MoyaProvider<BookShelfRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    // 1. 내 책장 (메인 뷰) 조회 하기
    
    func getMyBookShelfInfo(completion: @escaping (NetworkResult<Any>) -> Void) {
        bookShelfProvider.request(.getMyBookShelf) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeMyBookShelfInfoStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    private func judgeMyBookShelfInfoStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GeneralResponse<MyBookShelfResponse>.self, from: data)
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
