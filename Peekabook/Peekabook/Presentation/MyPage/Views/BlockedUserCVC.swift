//
//  BlockedUserCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/29.
//

import UIKit

import SnapKit

// MARK: - Protocols

protocol UnblockableButton: Unblockable {
    func didPressUnblockedButton(index: Int?)
}

final class BlockedUserCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: UnblockableButton?
    var selectedUserIndex: Int?
    
    // MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.image = ImageLiterals.Sample.profile1
        return iv
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "샘플유저"
        label.font = .h1
        label.textColor = .peekaRed
        return label
    }()
    
    private lazy var unblockButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.backgroundColor = .peekaRed
        bt.titleLabel!.font = .s3
        bt.setTitle(I18N.ManageBlockUsers.unblock, for: .normal)
        bt.setTitleColor(.peekaWhite, for: .normal)
        bt.addTarget(self, action: #selector(unblockedButtonDidTap), for: .touchUpInside)
        return bt
    }()
    
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

extension BlockedUserCVC {
    
    private func setUI() {
        backgroundColor = .peekaWhite.withAlphaComponent(0.4)
    }
    
    private func setLayout() {
        addSubviews(profileImageView, nickNameLabel, unblockButton)
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(45)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        unblockButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }
    }
    
    @objc
    private func unblockedButtonDidTap() {
        delegate?.didPressUnblockedButton(index: selectedUserIndex)
    }
}
