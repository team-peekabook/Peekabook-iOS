//
//  CheckVersion.swift
//  Peekabook
//
//  Created by 김인영 on 2023/11/09.
//

import UIKit

class AppVersionCheck {
    
    static func checkAppVersion(completion: @escaping (Bool) -> Void) {
        let userAPI = UserAPI()
        userAPI.checkVersion { response in
            guard let response = response else { return }
            guard let data = response.data else { return }
                
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            let forceVersion = data.iosForceVersion
                
            let splitForceVersion = forceVersion.split(separator: ".").map { $0 }
            let splitCurrentVersion = currentVersion.split(separator: ".").map { $0 }
                
            // major나 minor가 다른 경우
            if splitForceVersion[0] > splitCurrentVersion[0] ||
                splitForceVersion[0] == splitCurrentVersion[0] && splitForceVersion[1] > splitCurrentVersion[1] ||
                splitForceVersion[0] == splitCurrentVersion[0] && splitForceVersion[1] == splitCurrentVersion[1] && splitForceVersion[2] >= splitCurrentVersion[2] {
                print("😡😡😡😡 업데이트 하세욥 😡😡😡😡")
                completion(true)
            } else {
                print("😍😍😍😍 업데이트 노노필요 😍😍😍😍")
                completion(false)
            }
        }
    }
}
