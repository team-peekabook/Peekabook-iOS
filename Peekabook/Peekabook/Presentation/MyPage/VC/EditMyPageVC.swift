//
//  EditMyPageVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/03/23.
//

import UIKit

import SnapKit
import Then

import Moya

class EditMyPageVC: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton)
        .addMiddleLabel(title: I18N.Tabbar.editmyPage)
        .addRightButton(with: I18N.BookProposal.done)
        .addRightButtonAction {
            self.submitButtonDidTap()
        }
    
    private let profileImageContainerView = UIView()
    private let profileImageView = UIImageView().then {
        $0.image = ImageLiterals.Sample.profile1
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
    }
    private let editImageButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.profileImageEdit, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setLayout()
    }
    
    @objc private func submitButtonDidTap() {
        print("완료")
    }
}

// MARK: - UI & Layout

extension EditMyPageVC {
    
    private func setBackgroundColor() {
        view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, profileImageContainerView)
        profileImageContainerView.addSubviews(profileImageView, editImageButton)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageContainerView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(82)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(80)
        }
        
        editImageButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.height.width.equalTo(24)
        }
    }
}
