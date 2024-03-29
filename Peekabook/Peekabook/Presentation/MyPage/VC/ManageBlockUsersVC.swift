//
//  ManageBlockUsersVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/29.
//

import UIKit

import Moya
import SnapKit

// MARK: - Protocols

protocol Unblockable: AnyObject { }

final class ManageBlockUsersVC: UIViewController {
    
    // MARK: - Properties
    
    private var blockedList = [GetBlockedAccountResponse]()
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.ManageBlockUsers.blockedUsers)
        .addUnderlineView()
    
    private let emptyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textColor = .peekaRed_60
        label.text = I18N.ManageBlockUsers.noblockedUsers
        return label
    }()

    private let blockedUsersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 15, right: 0)
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        registerCells()
        setDelegate()
        getBlockedUserList()
    }
}

// MARK: - UI & Layout

extension ManageBlockUsersVC {
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, blockedUsersCollectionView, emptyDescriptionLabel)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        blockedUsersCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension ManageBlockUsersVC {
    
    private func registerCells() {
        blockedUsersCollectionView.register(BlockedUserCVC.self, forCellWithReuseIdentifier: BlockedUserCVC.className)
    }
    
    private func setDelegate() {
        blockedUsersCollectionView.delegate = self
        blockedUsersCollectionView.dataSource = self
    }
    
    private func setEmptyLabel(isHidden: Bool) {
        emptyDescriptionLabel.isHidden = !isHidden
        blockedUsersCollectionView.isHidden = isHidden
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ManageBlockUsersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return blockedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlockedUserCVC.className, for: indexPath)
                as? BlockedUserCVC else { return UICollectionViewCell() }
        cell.delegate = self
        cell.setData(blockedList[safe: indexPath.item]!)
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout

extension ManageBlockUsersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - Unblockable Implementations

extension ManageBlockUsersVC: UnblockableButton, UnblockablePopUp {
    
    func didPressUnblockedButton(_ nickName: String, _ userId: Int) {
        let unblockPopUpVC = UnblockPopUpVC(selectedUserId: userId)
        unblockPopUpVC.modalPresentationStyle = .overFullScreen
        unblockPopUpVC.delegate = self
        unblockPopUpVC.setData(nickName: nickName)
        self.present(unblockPopUpVC, animated: false)
    }
    
    func didPressUnblockedPopUp(_ userId: Int) {
        unblockAccount(with: userId)
    }
}

// MARK: - Network

extension ManageBlockUsersVC {
    
    private func getBlockedUserList() {
        MyPageAPI(viewController: self).getBlockedAccountList { response in
            if response?.success == true {
                self.blockedList = response?.data ?? []
                self.blockedUsersCollectionView.reloadData()
                self.setEmptyLabel(isHidden: response?.data?.isEmpty ?? true)
            }
        }
    }
    
    private func unblockAccount(with userId: Int) {
        MyPageAPI(viewController: self).unblockAccount(userId: userId) { response in
            if response?.success == true {
                self.presentedViewController?.dismiss(animated: false)
                self.getBlockedUserList()
            }
        }
    }
}
