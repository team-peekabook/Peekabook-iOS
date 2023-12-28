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
    
    private let containerView = UIView()
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
        view.backgroundColor = .peekaBeige
        containerView.backgroundColor = .black.withAlphaComponent(0.7)
        forceUpdatePopUpVC.backgroundColor = .peekaBeige
        forceUpdatePopUpVC.getConfirmLabel(style: .forceUpdate)
    }
    
    private func setLayout() {
        view.addSubviews(containerView)
        containerView.addSubview(forceUpdatePopUpVC)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        forceUpdatePopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
    
    private func openAppStore() {
        let appleID = Config.appleID
        let url = "itms-apps://itunes.apple.com/app/apple-store/" + appleID
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func confirmButtonDidTap() {
        openAppStore()
    }
}
