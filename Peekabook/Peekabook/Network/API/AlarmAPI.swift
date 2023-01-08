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
    
}
