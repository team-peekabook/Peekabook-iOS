//
//  UserSearchVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class UserSearchVC: UIViewController {
    
    // MARK: - Properties
    
    private let bookShelfVC = BookShelfVC()
    private var serverGetUserData: SearchUserResponse?
    
    private var friendId: Int = 0
    private var isFollowingStatus: Bool = false
    
    // MARK: - UI Components
    
    private lazy var headerView = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Tabbar.userSearch)
        .addUnderlineView()
    
    private lazy var userSearchView = CustomSearchView(frame: .zero, type: .userSearch, viewController: self)
    
    private let emptyView = UIView()
    private let emptyImgView = UIImageView().then {
        $0.image = ImageLiterals.Icn.empty
    }
    private let emptyLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed_60
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.text = I18N.ErrorPopUp.emptyUser
    }
    
    private let friendProfileContainerView = UIView()
    private let profileImage = UIImageView().then {
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
        $0.backgroundColor = .peekaRed
        $0.addTarget(self, action: #selector(followButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func followButtonDidTap() {
        isFollowingStatus.toggle()
        if isFollowingStatus {
            followed()
            postFollowAPI(friendId: friendId)
        } else {
            unfollowed()
            deleteFollowAPI(friendId: friendId)
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchView.setSearchTextFieldDelegate(self)
        setUI()
        setLayout()
        setBlankView()
    }
    
    @objc private func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func searchBtnTapped() {
        guard let friendName = userSearchView.text else { return }
        getUserAPI(nickname: friendName)
    }
}

// MARK: - UI & Layout

extension UserSearchVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        emptyView.backgroundColor = .clear
        friendProfileContainerView.backgroundColor = .white
    }
    
    private func setEmptyView() {
        self.friendProfileContainerView.isHidden = true
        self.emptyView.isHidden = false
    }
    
    private func setSuccessView() {
        self.emptyView.isHidden = true
        self.friendProfileContainerView.isHidden = false
    }
    
    private func setFollowStatus() {
        if followButton.isSelected {
            followed()
        } else {
            unfollowed()
        }
    }
    
    private func setBlankView() {
        emptyView.isHidden = true
        friendProfileContainerView.isHidden = true
    }
    
    private func setLayout() {
        view.addSubviews(userSearchView,
                         friendProfileContainerView,
                         headerView,
                         emptyView
        )
        emptyView.addSubviews(emptyImgView, emptyLabel)
        friendProfileContainerView.addSubviews(
            [profileImage,
            nameLabel,
            followButton]
        )
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        userSearchView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(40)
        }
        
        emptyView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userSearchView).offset(204)
            $0.height.equalTo(96)
            $0.width.equalTo(247)
        }
        emptyImgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImgView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        friendProfileContainerView.snp.makeConstraints {
            $0.top.equalTo(userSearchView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(176)
        }
        profileImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
            $0.height.width.equalTo(56)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        followButton.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(82)
            $0.height.equalTo(32)
        }
    }
}

// MARK: - Methods

extension UserSearchVC {
    
    private func followed() {
        followButton.backgroundColor = .peekaGray2
        followButton.setTitle(I18N.FollowStatus.following, for: .normal)
        profileImage.layer.borderColor = UIColor.peekaGray2.cgColor
    }
    private func unfollowed() {
        followButton.backgroundColor = .peekaRed
        followButton.setTitle(I18N.FollowStatus.follow, for: .normal)
        profileImage.layer.borderColor = UIColor.peekaRed.cgColor
    }
}

extension UserSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBtnTapped()
        userSearchView.endEditing()
        return true
    }
}

// MARK: - Network

extension UserSearchVC {
    private func getUserAPI(nickname: String) {
        FriendAPI.shared.searchUserData(nickname: nickname) { response in
            if response?.success == true {
                guard let serverGetUserData = response?.data else { return }
                self.nameLabel.text = serverGetUserData.nickname
                self.profileImage.kf.indicatorType = .activity
                self.profileImage.kf.setImage(with: URL(string: serverGetUserData.profileImage))
                self.followButton.isSelected = serverGetUserData.isFollowed
                self.isFollowingStatus = self.followButton.isSelected
                self.friendId = serverGetUserData.friendID
                self.setFollowStatus()
                self.setSuccessView()
            } else {
                self.setEmptyView()
            }
        }
    }
    
    private func postFollowAPI(friendId: Int) {
        FriendAPI.shared.postFollowing(id: friendId) { response in
            if response?.success == true {
                self.isFollowingStatus = true
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
    
    private func deleteFollowAPI(friendId: Int) {
        FriendAPI.shared.deleteFollowing(id: friendId) { response in
            if response?.success == true {
                self.isFollowingStatus = false
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
