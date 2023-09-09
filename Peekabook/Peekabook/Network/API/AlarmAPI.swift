//
//  AlarmAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import UIKit

import Moya

final class AlarmAPI {
    
    private var alarmProvider = MoyaProvider<AlarmRouter>(plugins: [MoyaLoggerPlugin(viewController: nil)])
    
    init(viewController: UIViewController) {
        alarmProvider = MoyaProvider<AlarmRouter>(plugins: [MoyaLoggerPlugin(viewController: viewController)])
    }
    
    // 1. 팔로우 알림 조회하기
    func getAlarmAPI(completion: @escaping (GeneralResponse<[GetAlarmResponse]>?) -> Void) {
        alarmProvider.request(.getAlarm) { result in
            switch result {
            case .success(let response):
                do {
                    let getAlarmData = try response.map(GeneralResponse<[GetAlarmResponse]>.self)
                    completion(getAlarmData)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
}
