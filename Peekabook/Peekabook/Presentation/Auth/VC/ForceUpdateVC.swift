//
//  ForceUpdateVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/11/30.
//

import UIKit

import SnapKit
import Then

import Moya

final class ForceUpdateVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var forceUpdatePopUpVC = CustomPopUpView(frame: .zero, style: .forceUpdate, viewController: self)

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("plz..............I'm here.......")
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension ForceUpdateVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        forceUpdatePopUpVC.backgroundColor = .peekaBeige
        forceUpdatePopUpVC.getConfirmLabel(style: .forceUpdate)
    }
    
    private func setLayout() {
        view.addSubview(forceUpdatePopUpVC)
        
        forceUpdatePopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
    
    private func openAppStore() {
        let appleID = Config.appleID
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleID)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func confirmButtonDidTap() {
        openAppStore()
        self.dismiss(animated: false, completion: nil)
    }
}
