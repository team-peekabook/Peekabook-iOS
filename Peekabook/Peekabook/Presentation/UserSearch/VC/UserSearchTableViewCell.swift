//
//  UserSearchTableViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/05.
//

import UIKit
import SnapKit
import Then

class UserSearchTableViewCell: UITableViewCell {
    
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
        $0.textColor = UIColor.peekaRed
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private lazy var followButton = UIButton().then {
        $0.setTitle("팔로우", for: .normal)
        $0.setTitleColor(UIColor.peekaWhite, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = UIColor.peekaRed
        $0.addTarget(self, action: #selector(followButtonDidTap), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setLayout()
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

extension UserSearchTableViewCell {
    
    private func selected() {
        followButton.backgroundColor = UIColor.peekaGray2
        followButton.setTitle("팔로잉", for: .normal)
        followButton.isSelected = true
    }
    private func deselected() {
        followButton.backgroundColor = UIColor.peekaRed
        followButton.setTitle("팔로우", for: .normal)
        followButton.isSelected = true
    }
    
    private func setLayout() {
        
        contentView.addSubviews([profileImage,
                                 nameLabel,
                                 followButton])
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
    
    func dataBind(model: UserSearchModel) {
        nameLabel.text = model.name
    }
}
