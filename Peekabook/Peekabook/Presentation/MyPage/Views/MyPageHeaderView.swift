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
    private let editButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.profileEdit, for: .normal)
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
}

extension MyPageHeaderView {
    private func setLayout() {
        containerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: URL(string: UserDefaults.standard.string(forKey: "userProfileImage") ?? ""))
        introLabel.text = UserDefaults.standard.string(forKey: "userIntro")
        nameLabel.text = UserDefaults.standard.string(forKey: "userNickname")
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubviews(headerLineview, bottomLineview, profileImageView, nameLabel, editButton, introLabel)
        
        headerLineview.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(13)
        }
        
        editButton.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(-12)
            make.centerY.equalTo(nameLabel)
            make.height.width.equalTo(48)
        }
        
        introLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.trailing.equalToSuperview().inset(10)
        }
        
        bottomLineview.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
            make.bottom.equalToSuperview()
        }
    }
}
