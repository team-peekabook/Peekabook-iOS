//
//  DeleteAccountVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/25.
//

import UIKit

import SnapKit
import Then

import Moya

final class DeleteAccountVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.DeleteAccount.title)
        .addUnderlineView()
    
    private let deleteAccountImgView = UIImageView().then {
        $0.image = ImageLiterals.Icn.deleteAccount
    }
    
    private let deleteAccountLabel = UILabel().then {
        $0.font = .h2
        $0.text = I18N.DeleteAccount.deleteAccountComment
        $0.textColor = .peekaRed
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var deleteAccountButton = UIButton(type: .system).then {
        $0.setTitle(I18N.DeleteAccount.button, for: .normal)
        $0.titleLabel!.font = .h3
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(deleteAccountButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setLayout()
        addTapGesture()
    }
}

// MARK: - UI & Layout

extension DeleteAccountVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        deleteAccountButton.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, deleteAccountImgView, deleteAccountLabel, deleteAccountButton)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        deleteAccountImgView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(225)
            $0.centerX.equalToSuperview()
        }
        
        deleteAccountLabel.snp.makeConstraints {
            $0.top.equalTo(deleteAccountImgView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56.adjustedH)
        }
    }
}

// MARK: - Methods

extension DeleteAccountVC {
    // MARK: - @objc Function
    
    @objc private func deleteAccountButtonDidTap() {
        let deleteAccountPopUpVC = DeleteAccountPopUpVC()
        deleteAccountPopUpVC.modalPresentationStyle = .overFullScreen
        self.present(deleteAccountPopUpVC, animated: false)
    }
}
