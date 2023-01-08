//
//  RecommendAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

final class RecommendAPI {
    
    static let shared = RecommendAPI()
    private var recommendProvider = MoyaProvider<RecommendRouter>(plugins: [MoyaLoggerPlugin()])
    
    private init() { }
    
}
