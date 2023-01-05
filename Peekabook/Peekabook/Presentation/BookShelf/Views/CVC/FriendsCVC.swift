//
//  FriendsCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

final class FriendsCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
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
    
    func initCell(model: SampleFriendsModel) {
        profileImageView.image = model.profileImage
        userNameLabel.text = model.name
    }
    
    private func setUI() {
        contentView.backgroundColor = .peekaBeige
        backgroundColor = .clear
    }
    
    private func setLayout() {
        addSubviews(profileImageView, userNameLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
    }
}
