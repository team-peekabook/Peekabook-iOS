//
//  LogoutPopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/25.
//

import UIKit

import SnapKit
import Then

import Moya

final class LogoutPopUpVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var logoutPopUpVC = CustomPopUpView(frame: .zero, style: .logout, viewController: self)

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension LogoutPopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        logoutPopUpVC.backgroundColor = .peekaBeige
        logoutPopUpVC.getConfirmLabel(style: .logout)
    }
    
    private func setLayout() {
        view.addSubview(logoutPopUpVC)
        
        logoutPopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension LogoutPopUpVC {
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func confirmButtonDidTap() {
        print("a")
    }
}
