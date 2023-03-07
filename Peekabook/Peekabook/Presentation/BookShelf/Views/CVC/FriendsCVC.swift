//
//  FriendsCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

final class FriendsCVC: UICollectionViewCell {
    
    // MARK: - Properties

    var userId: Int = 0
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .s2
        $0.textAlignment = .center
        $0.textColor = .peekaRed
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension FriendsCVC {
    
    private func setUI() {
        contentView.backgroundColor = .peekaBeige
        backgroundColor = .clear
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.peekaBeige.cgColor
    }
    
    private func setLayout() {
        addSubviews(profileImageView, userNameLabel)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(5)
        }
    }
    
    func setData(model: MyIntro) {
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: URL(string: model.profileImage ?? ""))
        userNameLabel.text = model.nickname
        userId = model.id
    }
    
    func changeBorderLayout(isSelected: Bool) {
        if isSelected {
            profileImageView.layer.borderColor = UIColor.peekaRed.cgColor
            userNameLabel.font = .s1
        } else {
            profileImageView.layer.borderColor = UIColor.peekaBeige.cgColor
            userNameLabel.font = .s2
        }
    }
}
