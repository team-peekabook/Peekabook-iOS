//
//  ManageBlockUsersVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/29.
//

import UIKit

import Moya
import SnapKit

final class ManageBlockUsersVC: UIViewController {
            
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.ManageBlockUsers.blockedUsers)
        .addUnderlineView()

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
    }
}

// MARK: - UI & Layout

extension ManageBlockUsersVC {
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, blockedUsersCollectionView)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        blockedUsersCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ManageBlockUsersVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlockedUserCVC.className, for: indexPath)
                as? BlockedUserCVC else { return UICollectionViewCell() }
        cell.delegate = self
        cell.indexPath = indexPath.row
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

// MARK: - Unblockable

extension ManageBlockUsersVC: UnblockableButton, UnblockablePopUp {
    
    func didPressUnblockedButton(index: Int?) {
        let unblockPopUpVC = UnblockPopUpVC()
        unblockPopUpVC.modalPresentationStyle = .overFullScreen
        unblockPopUpVC.selectedUserIndex = index
        
        self.present(unblockPopUpVC, animated: false)
    }
    
    func didPressUnblockedPopUp(index: Int) {
        print("\(index) 차단해제 서버 붙이기")
    }
}
