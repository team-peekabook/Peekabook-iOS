//
//  MyPageHeaderView.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/14.
//

import UIKit
import SnapKit
import Then

final class MyPageHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    var editButtonTappedClosure: (() -> Void)?
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    
    private let headerLineview = DoubleHeaderLineView()
    private let bottomLineview = DoubleBottomLineView()
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 30
    }
    private let nameLabel = UILabel().then {
        $0.font = .h1
        $0.textColor = .peekaRed
    }
    private lazy var editButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.profileEdit, for: .normal)
        $0.addTarget(self, action: #selector(editMyProfileButtonDidTap), for: .touchUpInside)
    }
    private let introLabel = UILabel().then {
        $0.font = .s3
        $0.numberOfLines = 2
        $0.textColor = .peekaRed
    }
    
    // MARK: - LifeCycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func editMyProfileButtonDidTap() {
        editButtonTappedClosure?()
    }
    
    func dataBind(dataModel: GetAccountResponse) {
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: URL(string: dataModel.profileImage))
        introLabel.text = dataModel.intro
        nameLabel.text = dataModel.nickname
    }
}

extension MyPageHeaderView {
    private func setLayout() {
        containerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: URL(string: UserDefaults.standard.string(forKey: "userProfileImage") ?? ""))
        introLabel.text = UserDefaults.standard.string(forKey: "userIntro")
        nameLabel.text = UserDefaults.standard.string(forKey: "userNickname")
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubviews(headerLineview, bottomLineview, profileImageView, nameLabel, editButton, introLabel)
        
        headerLineview.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(13)
        }
        
        editButton.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.trailing).offset(-12)
            $0.centerY.equalTo(nameLabel)
            $0.height.width.equalTo(48)
        }
        
        introLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(3)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        bottomLineview.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
            $0.bottom.equalToSuperview()
        }
    }
}
