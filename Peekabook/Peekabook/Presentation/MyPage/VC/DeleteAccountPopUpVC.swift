//
//  DeleteAccountPopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/27.
//

import UIKit

import SnapKit
import Then

import Moya

final class DeleteAccountPopUpVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var deleteAccountPopUpVC = CustomPopUpView(frame: .zero, style: .deleteAccount, viewController: self)

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension DeleteAccountPopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        deleteAccountPopUpVC.backgroundColor = .peekaBeige
        deleteAccountPopUpVC.getConfirmLabel(style: .deleteAccount)
    }
    
    private func setLayout() {
        view.addSubview(deleteAccountPopUpVC)
        
        deleteAccountPopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension DeleteAccountPopUpVC {
    
    @objc func confirmButtonDidTap() {
        deleteAccount()
    }
}

// MARK: - Network

extension DeleteAccountPopUpVC {
    private func deleteAccount() {
        MyPageAPI(viewController: self).deleteAccount { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: LoginVC(), animated: true, completion: nil)
                UserDefaults.standard.removeObject(forKey: "socialToken")
                UserDefaults.standard.removeObject(forKey: "accessToken")
                UserDefaults.standard.removeObject(forKey: "refreshToken")
            }
        }
    }
}
