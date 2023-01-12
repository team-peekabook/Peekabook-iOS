//
//  AlarmAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

final class AlarmAPI {
    
    static let shared = AlarmAPI()
    private var alarmProvider = MoyaProvider<AlarmRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
    private(set) var getAlarmData: GeneralResponse<[GetAlarmResponse]>?
    
    // 1. 팔로우 알림 조회하기
    
    func getAlarmAPI(completion: @escaping (GeneralResponse<[GetAlarmResponse]>?) -> Void) {
        alarmProvider.request(.getAlarm) { [self] (result) in
            switch result {
            case .success(let response):
                do {
                    self.getAlarmData = try response.map(GeneralResponse<[GetAlarmResponse]>.self)
                    completion(getAlarmData)
                } catch let error {
                    print(error.localizedDescription, 500)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
