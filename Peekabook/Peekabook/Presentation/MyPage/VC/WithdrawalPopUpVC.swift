//
//  WithdrawalPopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/27.
//

import UIKit

import SnapKit
import Then

import Moya

final class WithdrawalPopUpVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var withdrawalPopUpVC = CustomPopUpView(frame: .zero, style: .withdrawal, viewController: self)

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension WithdrawalPopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        withdrawalPopUpVC.backgroundColor = .peekaBeige
        withdrawalPopUpVC.getConfirmLabel(style: .withdrawal)
    }
    
    private func setLayout() {
        view.addSubview(withdrawalPopUpVC)
        
        withdrawalPopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension WithdrawalPopUpVC {
    
    @objc func confirmButtonDidTap() {
        print("탈퇴완료")
        self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
    }
}
