//
//  WithdrawalVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/25.
//

import UIKit

import SnapKit
import Then

import Moya

final class WithdrawalVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Withdrawal.title)
        .addUnderlineView()
    
    private let withdrawalImgView = UIImageView().then {
        $0.image = ImageLiterals.Icn.leave
    }
    
    private let withdrawalLabel = UILabel().then {
        $0.font = .h2
        $0.text = I18N.Withdrawal.withdrawalComment
        $0.textColor = .peekaRed
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var withdrawalButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Withdrawal.button, for: .normal)
        $0.titleLabel!.font = .h3
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(withdrawalButtonDidTap), for: .touchUpInside)
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

extension WithdrawalVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        withdrawalButton.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, withdrawalImgView, withdrawalLabel, withdrawalButton)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        withdrawalImgView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(225)
            $0.centerX.equalToSuperview()
        }
        
        withdrawalLabel.snp.makeConstraints {
            $0.top.equalTo(withdrawalImgView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.top.equalTo(withdrawalLabel.snp.bottom).offset(260)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
}

// MARK: - Methods

extension WithdrawalVC {
    // MARK: - @objc Function
    
    @objc private func withdrawalButtonDidTap() {
        let withdrawalViewController = WithdrawalPopUpVC()
        withdrawalViewController.modalPresentationStyle = .overFullScreen
        self.present(withdrawalViewController, animated: false)
    }
}
