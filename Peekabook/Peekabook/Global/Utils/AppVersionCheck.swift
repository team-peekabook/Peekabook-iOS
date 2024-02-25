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
                
            if splitForceVersion[0] > splitCurrentVersion[0] ||
                splitForceVersion[0] == splitCurrentVersion[0] && splitForceVersion[1] > splitCurrentVersion[1] {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
