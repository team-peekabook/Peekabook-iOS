//
//  LeaveVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/25.
//

import UIKit

import SnapKit
import Then

import Moya

final class LeaveVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Leave.title)
        .addUnderlineView()
    
    private let leaveImgView = UIImageView().then {
        $0.image = ImageLiterals.Icn.leave
    }
    
    private let leaveLabel = UILabel().then {
        $0.font = .h2
        $0.text = I18N.Leave.leaveComment
        $0.textColor = .peekaRed
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var declareButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Leave.button, for: .normal)
        $0.titleLabel!.font = .h3
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(declareButtonDidTap), for: .touchUpInside)
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

extension LeaveVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        declareButton.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, leaveImgView, leaveLabel, declareButton)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        leaveImgView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(225)
            $0.centerX.equalToSuperview()
        }
        
        leaveLabel.snp.makeConstraints {
            $0.top.equalTo(leaveImgView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        declareButton.snp.makeConstraints {
            $0.top.equalTo(leaveLabel.snp.bottom).offset(260)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
}

// MARK: - Methods

extension LeaveVC {
    // MARK: - @objc Function
    
    @objc private func declareButtonDidTap() {
        print("울랄라")
    }
}
