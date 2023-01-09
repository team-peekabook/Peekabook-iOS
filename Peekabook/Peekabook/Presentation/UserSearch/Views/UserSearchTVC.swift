//
//  UserSearchTableViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/05.
//

import UIKit
import SnapKit
import Then

class UserSearchTVC: UITableViewCell {
    
    var isFollowing: Bool = false {
        didSet {
            isFollowing == true ? selected() : deselected()
        }
    }
    
    private let profileImage = UIImageView().then {
        $0.image = ImageLiterals.Sample.profile6
        $0.layer.borderWidth = 3
        $0.layer.borderColor = UIColor.peekaRed.cgColor
        $0.layer.cornerRadius = 28
        $0.layer.masksToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .peekaRed
        $0.font = .h1
    }
    
    private lazy var followButton = UIButton().then {
        $0.setTitle(I18N.FollowStatus.follow, for: .normal)
        $0.setTitleColor(.peekaWhite, for: .normal)
        $0.titleLabel?.font = .s3
        $0.addTarget(self, action: #selector(followButtonDidTap), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setLayout()
            setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func followButtonDidTap() {
        isFollowing.toggle()
        followButton.isSelected = isFollowing
        print(followButton.isSelected)
    }
}

// MARK: - UI & Layout

extension UserSearchTVC {
    
    private func setUI() {
        followButton.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        
        contentView.addSubviews(
            [profileImage,
            nameLabel,
            followButton]
        )
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24)
            make.height.width.equalTo(56)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        followButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(82)
            make.height.equalTo(32)
        }
    }
}

// MARK: - Methods

extension UserSearchTVC {
    
    private func selected() {
        followButton.backgroundColor = .peekaGray2
        followButton.setTitle(I18N.FollowStatus.following, for: .normal)
        followButton.isSelected = true
    }
    private func deselected() {
        followButton.backgroundColor = .peekaRed
        followButton.setTitle(I18N.FollowStatus.follow, for: .normal)
        followButton.isSelected = true
    }
    
    func dataBind(model: UserSearchModel) {
        nameLabel.text = model.name
    }
}
