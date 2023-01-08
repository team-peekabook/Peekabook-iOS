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
    
}
