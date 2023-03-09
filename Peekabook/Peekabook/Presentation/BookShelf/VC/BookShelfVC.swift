//
//  BookShelfVC.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import SnapKit
import Then

import Moya

enum BookShelfType: CaseIterable {
    case user
    case friend
}

final class BookShelfVC: UIViewController {
    
    // MARK: - Properties
    
    private var bookShelfType: BookShelfType = .user {
        didSet {
            switch bookShelfType {
            case .user:
                bottomShelfVC.changeLayout(wantsToHide: false)
                editOrRecommendButton.setTitle(I18N.BookShelf.editPick, for: .normal)
            case .friend:
                bottomShelfVC.changeLayout(wantsToHide: true)
                editOrRecommendButton.setTitle(I18N.BookShelf.recommendBook, for: .normal)
            }
        }
    }
    
    private var serverMyBookShelfInfo: MyBookShelfResponse?
    private var serverFriendBookShelfInfo: FriendBookShelfResponse?

    private var friends: [MyIntro] = []
    private var picks: [Pick] = []
    
    private var selectedUserIndex: Int? {
        didSet {
            changeUserLayout(selectedIndex: selectedUserIndex)
            if selectedUserIndex == nil {
                getMyBookShelfInfo()
                bookShelfType = .user
                bottomShelfVC.bookShelfType = .user
            } else {
                getFriendBookShelfInfo(userId: friends[selectedUserIndex ?? 0].id)
                bookShelfType = .friend
                bottomShelfVC.bookShelfType = .friend
            }
        }
    }
    
    // MARK: - UI Components
    
    private let bottomShelfVC = BottomBookShelfVC()
    private let containerScrollView = UIScrollView()
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithTwoRightButtons)
        .changeLeftBackButtonToLogoImage()
        .addRightButton(with: ImageLiterals.Icn.notification)
        .addOtherRightButtonImage(ImageLiterals.Icn.friend)
        .addRightButtonAction {
            self.presentNotiVC()
        }
        .addOtherRightButtonAction {
            self.pushUserSearchVC()
        }
    
    private let friendsListContainerView = UIView()
    private let introProfileView = UIView()
    private let pickContainerView = UIView()
    
    private let myProfileView = UIView()
    private let horizontalLine1 = UIView()
    private let horizontalLine2 = UIView()
    private let verticalLine = UIView()
    private let doubleheaderLine = DoubleHeaderLineView()
    private let doubleBottomLine = DoubleBottomLineView()
    
    private lazy var friendsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let myProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.borderColor = UIColor.peekaRed.cgColor
        $0.layer.borderWidth = 3
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    private let myNameLabel = UILabel().then {
        $0.font = .s1
        $0.textColor = .peekaRed
        $0.textAlignment = .center
    }
    
    private let introNameLabel = UILabel().then {
        $0.font = .nameBold
        $0.textColor = .peekaRed
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private let introductionLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }
    
    private let pickLabel = UILabel().then {
        $0.text = I18N.BookShelf.pick
        $0.font = .engSb
        $0.textColor = .peekaRed
    }
    
    private lazy var editOrRecommendButton = UIButton(type: .system).then {
        $0.titleLabel!.font = .c1
        $0.setTitle(I18N.BookShelf.editPick, for: .normal)
        $0.setTitleColor(.peekaRed, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.peekaRed.cgColor
        $0.addTarget(self, action: #selector(editOrRecommendButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var pickCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let emptyView = UIView()
    
    private let emptyPickViewDescription = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed_60
        $0.textAlignment = .center
        $0.numberOfLines = 3
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        setTapGesture()
        registerCells()
        addBottomSheetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedUserIndex == nil {
            getMyBookShelfInfo()
        }
    }
    
    // MARK: - @objc Function
    
    @objc
    private func editOrRecommendButtonDidTap() {
        switch bookShelfType {
        case .user:
            let editPickVC = EditMyPickVC()
            editPickVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editPickVC, animated: true)
        case .friend:
            let bookSearchVC = BookSearchVC()
            bookSearchVC.bookShelfType = .friend
            guard let friend = serverMyBookShelfInfo?.friendList[selectedUserIndex!] else { return }
            bookSearchVC.personName = friend.nickname
            bookSearchVC.personId = friend.id
            bookSearchVC.hidesBottomBarWhenPushed = true
            bookSearchVC.modalPresentationStyle = .fullScreen
            present(bookSearchVC, animated: true)
        }
    }
    
    @objc
    private func myProfileViewDidTap() {
        getMyBookShelfInfo()
        selectedUserIndex = nil
    }
}

// MARK: - UI & Layout

extension BookShelfVC {
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
        horizontalLine1.backgroundColor = .peekaRed
        horizontalLine2.backgroundColor = .peekaRed
        verticalLine.backgroundColor = .peekaRed
        myProfileView.backgroundColor = .peekaBeige
        introProfileView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        editOrRecommendButton.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        friendsCollectionView.backgroundColor = .peekaBeige
        pickCollectionView.backgroundColor = .peekaBeige
        containerScrollView.showsVerticalScrollIndicator = false
        containerScrollView.bounces = false
    }
    
    private func setLayout() {
        
        view.addSubviews(naviBar, containerScrollView)
        containerScrollView.addSubviews(friendsListContainerView, introProfileView, pickContainerView)
        
        friendsListContainerView.addSubviews(myProfileView, verticalLine, friendsCollectionView, horizontalLine1, horizontalLine2)
        myProfileView.addSubviews(myProfileImageView, myNameLabel)
        introProfileView.addSubviews(introNameLabel, introductionLabel, doubleheaderLine, doubleBottomLine)
        pickContainerView.addSubviews(pickLabel, editOrRecommendButton, pickCollectionView, emptyView)
        
        emptyView.addSubview(emptyPickViewDescription)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview().inset(180.adjustedH)
        }
        
        friendsListContainerView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(84)
        }
        
        introProfileView.snp.makeConstraints {
            $0.top.equalTo(friendsListContainerView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(70)
        }
        
        pickContainerView.snp.makeConstraints {
            $0.top.equalTo(introProfileView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        myProfileView.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(84)
        }
        
        myProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        myNameLabel.snp.makeConstraints {
            $0.top.equalTo(myProfileImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        verticalLine.snp.makeConstraints {
            $0.leading.equalTo(myProfileView.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(62)
        }
        
        friendsCollectionView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.leading.equalTo(verticalLine.snp.trailing)
            $0.height.equalTo(86)
        }
        
        horizontalLine1.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        horizontalLine2.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        doubleheaderLine.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        introNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        introductionLabel.snp.makeConstraints {
            $0.leading.equalTo(introNameLabel.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        doubleBottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        pickLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().offset(20)
        }
        
        editOrRecommendButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(70)
            $0.height.equalTo(25)
        }
        
        pickCollectionView.snp.makeConstraints {
            $0.top.equalTo(pickLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(270)
        }
        
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(70)
        }
        
        emptyPickViewDescription.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        checkSmallLayout()
    }
}

// MARK: - Methods

extension BookShelfVC {
    
    private func presentNotiVC() {
        let vc = MyNotificationVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func pushUserSearchVC() {
        let vc = UserSearchVC()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addBottomSheetView(scrollable: Bool? = true) {
        self.view.addSubview(bottomShelfVC.view)
        self.addChild(bottomShelfVC)
        bottomShelfVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        
        bottomShelfVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    private func setDelegate() {
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        
        pickCollectionView.delegate = self
        pickCollectionView.dataSource = self
    }
    
    private func registerCells() {
        friendsCollectionView.register(FriendsCVC.self, forCellWithReuseIdentifier: FriendsCVC.className)
        pickCollectionView.register(PickCVC.self, forCellWithReuseIdentifier: PickCVC.className)
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(myProfileViewDidTap))
        myProfileView.addGestureRecognizer(tap)
    }
    
    private func changeUserLayout(selectedIndex: Int?) {
        if selectedIndex == nil {
            myProfileImageView.layer.borderColor = UIColor.peekaRed.cgColor
            myNameLabel.font = .s1
        } else {
            myProfileImageView.layer.borderColor = UIColor.peekaBeige.cgColor
            myNameLabel.font = .s2
        }
    }
    
    private func setEmptyView(description: String) {
        if picks.isEmpty {
            emptyView.isHidden = false
            pickCollectionView.isHidden = true
            emptyPickViewDescription.text = description
        } else {
            emptyView.isHidden = true
            pickCollectionView.isHidden = false
        }
    }
    
    private func checkSmallLayout() {
        if UIScreen.main.isSmallThan712pt {
            containerScrollView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(140.adjustedH)
            }
            
            pickContainerView.snp.makeConstraints {
                $0.top.equalTo(introProfileView.snp.bottom).offset(20)
            }
            
            pickCollectionView.snp.updateConstraints {
                $0.top.equalTo(pickLabel.snp.bottom).offset(10)
                $0.height.equalTo(230)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BookShelfVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == friendsCollectionView {
            return friends.count
        } else if collectionView == pickCollectionView {
            return picks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == friendsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCVC.className, for: indexPath)
                    as? FriendsCVC else { return UICollectionViewCell() }
            cell.setData(model: friends[safe: indexPath.row]!)
            
            if selectedUserIndex == indexPath.row {
                cell.changeBorderLayout(isSelected: true)
            } else {
                cell.changeBorderLayout(isSelected: false)
            }
            return cell
        }
        
        if collectionView == pickCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickCVC.className, for: indexPath)
                    as? PickCVC else { return UICollectionViewCell() }
            cell.setData(model: picks[safe: indexPath.row]!)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == friendsCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? FriendsCVC else { return }
            cell.changeBorderLayout(isSelected: true)
            selectedUserIndex = indexPath.row
        }
        
        if collectionView == pickCollectionView {
            let bookDetailVC = BookDetailVC()
            switch bookShelfType {
            case .user:
                bookDetailVC.changeUserViewLayout()
            case .friend:
                bookDetailVC.changeFriendViewLayout()
            }
            bookDetailVC.hidesBottomBarWhenPushed = true
            bookDetailVC.selectedBookIndex = picks[safe: indexPath.row]!.id
            navigationController?.pushViewController(bookDetailVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FriendsCVC else { return }
        cell.changeBorderLayout(isSelected: false)
    }
}

// MARK: - UICollectionViewFlowLayout

extension BookShelfVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == friendsCollectionView {
            return CGSize(width: 60, height: 86)
        } else if collectionView == pickCollectionView {
            if UIScreen.main.isSmallThan712pt {
                return CGSize(width: 145, height: 210)
            }
            return CGSize(width: 145, height: 250)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == friendsCollectionView {
            return -5
        } else if collectionView == pickCollectionView {
            return 16
        }
        return 0
    }
}

// MARK: - Network

extension BookShelfVC {
    
    private func getMyBookShelfInfo() {
        BookShelfAPI.shared.getMyBookShelfInfo { response in
            self.serverMyBookShelfInfo = response?.data
            guard let response = response, let data = response.data else { return }
            self.myProfileImageView.kf.indicatorType = .activity
            self.myProfileImageView.kf.setImage(with: URL(string: (data.myIntro.profileImage ?? "")))
            self.myNameLabel.text = data.myIntro.nickname
            self.introNameLabel.text = data.myIntro.nickname
            self.introductionLabel.text = data.myIntro.intro
            self.friends = data.friendList
            self.picks = data.picks
            self.setEmptyView(description: I18N.BookShelf.emptyPickViewDescription)
            self.bottomShelfVC.setData(books: data.books,
                                       bookTotalNum: data.bookTotalNum)
            UserDefaults.standard.setValue(data.myIntro.nickname, forKey: "userNickname")
            UserDefaults.standard.setValue(data.myIntro.intro, forKey: "userIntro")
            UserDefaults.standard.setValue(data.myIntro.profileImage, forKey: "userProfileImage")
            self.friendsCollectionView.reloadData()
            self.pickCollectionView.reloadData()
        }
    }
    
    private func getFriendBookShelfInfo(userId: Int) {
        BookShelfAPI.shared.getFriendBookShelfInfo(friendId: userId) { response in
            self.serverFriendBookShelfInfo = response?.data
            guard let response = response, let data = response.data else { return }
            self.introNameLabel.text = data.friendIntro.nickname
            self.introductionLabel.text = data.friendIntro.intro
            self.picks = data.picks
            self.setEmptyView(description: I18N.BookShelf.emptyFriendPickDescription)
            self.bottomShelfVC.setData(books: data.books,
                                       bookTotalNum: data.bookTotalNum)
            self.pickCollectionView.reloadData()
        }
    }
}
