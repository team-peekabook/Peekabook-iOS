//
//  Providers.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/13.
//

import Foundation

import Moya

struct Providers {
    static let bookShelfProvider = MoyaProvider<BookShelfRouter>(withAuth: true)
    static let pickProvider = MoyaProvider<PickRouter>(withAuth: true)
    static let recommendProvider = MoyaProvider<RecommendRouter>(withAuth: true)
    static let friendProvider = MoyaProvider<FriendRouter>(withAuth: true)
    static let alarmProvider = MoyaProvider<AlarmRouter>(withAuth: true)
    static let naverSearchProvider = MoyaProvider<NaverSearchRouter>(withAuth: true)
    static let mypageProvider = MoyaProvider<MyPageRouter>(withAuth: true)
    static let userProvider = MoyaProvider<UserRouter>(withAuth: true)
    static let authProvider = MoyaProvider<AuthRouter>(withAuth: true)
}

extension MoyaProvider {
    convenience init(withAuth: Bool = true) {
        if withAuth {
            self.init(session: Session(interceptor: AuthInterceptor.shared),
                      plugins: [NetworkLoggerPlugin(verbose: true)])
        } else {
            self.init()
        }
    }
}
