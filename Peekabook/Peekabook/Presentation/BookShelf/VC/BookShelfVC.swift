//
//  BookShelfVC.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import Moya
import SnapKit

enum BookShelfType: CaseIterable {
    case user
    case friend
}

final class BookShelfVC: UIViewController {
    
    var isFollowingStatus: Bool = false
    
    // MARK: - Properties
    
    private var bookShelfType: BookShelfType = .user {
        didSet {
            switch bookShelfType {
            case .user:
                bottomShelfVC.changeLayout(isUser: false)
                editOrRecommendButton.setTitle(I18N.BookShelf.editPick, for: .normal)
                moreButton.isHidden = true
            case .friend:
                editOrRecommendButton.isEnabled = true
                bottomShelfVC.changeLayout(isUser: true)
                editOrRecommendButton.setTitle(I18N.BookShelf.recommendBook, for: .normal)
                moreButton.isHidden = false
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
        .addOtherRightButton(with: ImageLiterals.Icn.friend)
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
    
    private let myProfileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.peekaRed.cgColor
        iv.layer.borderWidth = 3
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 22
        return iv
    }()
    
    private let myNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = .s1
        lb.textColor = .peekaRed
        lb.textAlignment = .center
        return lb
    }()
    
    private let introNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = .nameBold
        lb.textColor = .peekaRed
        lb.textAlignment = .center
        lb.numberOfLines = 2
        return lb
    }()
    
    private let introductionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .h2
        lb.textColor = .peekaRed
        lb.textAlignment = .left
        lb.numberOfLines = 2
        lb.lineBreakMode = .byCharWrapping
        return lb
    }()
    
    private lazy var moreButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(ImageLiterals.Icn.more, for: .normal)
        bt.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        bt.isHidden = true
        return bt
    }()
    
    private let pickLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.BookShelf.pick
        lb.font = .engSb
        lb.textColor = .peekaRed
        return lb
    }()
    
    private lazy var editOrRecommendButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.titleLabel!.font = .c1
        bt.setTitle(I18N.BookShelf.editPick, for: .normal)
        bt.setTitleColor(.peekaRed, for: .normal)
        bt.layer.borderWidth = 1
        bt.layer.borderColor = UIColor.peekaRed.cgColor
        bt.addTarget(self, action: #selector(editOrRecommendButtonDidTap), for: .touchUpInside)
        return bt
    }()
    
    private lazy var pickCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let emptyPickView = UIView()
    
    private let emptyPickViewDescriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .h2
        lb.textColor = .peekaRed_60
        lb.textAlignment = .center
        lb.numberOfLines = 3
        lb.isHidden = true
        return lb
    }()
    
    private let emptyFriendsListDescriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .s3
        lb.textColor = .peekaRed_60
        return lb
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        setTapGesture()
        registerCells()
        addBottomSheetView()
        getCachedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedUserIndex == nil {
            getMyBookShelfInfo() // 백그라운드에서 서버로부터 최신 데이터 가져오기
        }
        updateLatestMyProfile() // 나의 미니 프로필 데이터 최신화
    }
    
    // MARK: - @objc Function
    
    @objc
    private func moreButtonDidTap(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: I18N.BookShelf.unfollow, style: .default, handler: {(ACTION: UIAlertAction) in
            
            let unfollowPopUpVC = UnfollowPopUpVC()
            unfollowPopUpVC.modalPresentationStyle = .overFullScreen
            guard let friend = self.serverMyBookShelfInfo?.friendList[self.selectedUserIndex!] else { return }
            unfollowPopUpVC.personName = friend.nickname
            unfollowPopUpVC.personId = friend.id
            self.present(unfollowPopUpVC, animated: false)
        }))
        
        actionSheet.addAction(UIAlertAction(title: I18N.BookShelf.report, style: .destructive, handler: {(ACTION: UIAlertAction) in
            
            let reportVC = ReportVC()
            guard let friend = self.serverMyBookShelfInfo?.friendList[self.selectedUserIndex!] else { return }
            reportVC.personId = friend.id
            reportVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(reportVC, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: I18N.BookShelf.block, style: .destructive, handler: {(ACTION: UIAlertAction) in
            
            let blockPopUpVC = BlockPopUpVC()
            guard let friend = self.serverMyBookShelfInfo?.friendList[self.selectedUserIndex!] else { return }
            blockPopUpVC.personId = friend.id
            blockPopUpVC.personName = friend.nickname
            blockPopUpVC.modalPresentationStyle = .overFullScreen
            self.present(blockPopUpVC, animated: false)
        }))
        
        actionSheet.addAction(UIAlertAction(title: I18N.BookShelf.cancel, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
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
    
    private func updateLatestMyProfile() {
        self.myProfileImageView.loadProfileImage(from: UserDefaultKeyList.userProfileImage)
        self.myNameLabel.text = UserDefaultKeyList.userNickname
    }
    
    private func updateUI(with data: MyBookShelfResponse) {
        self.serverMyBookShelfInfo = data
        self.myProfileImageView.loadProfileImage(from: data.myIntro.profileImage)
        self.myNameLabel.text = data.myIntro.nickname
        self.introNameLabel.text = data.myIntro.nickname
        self.introductionLabel.text = data.myIntro.intro
        self.friends = data.friendList
        self.picks = data.picks
        self.bottomShelfVC.setData(books: data.books, bookTotalNum: data.bookTotalNum)
        
        self.checkEmptyFriendListView(isEnabled: data.friendList.isEmpty)
        self.checkEmptyPickView(description: I18N.BookShelf.emptyPickViewDescription, bool: data.picks.isEmpty)
        self.editPickButtonState(with: data.books.isEmpty)
        self.bottomShelfVC.setEmptyLayout(data.books.isEmpty)
        self.friendsCollectionView.reloadData()
        self.pickCollectionView.reloadData()
    }
    
    private func getCachedData() {
        if let cachedData = UserDefaults.standard.getMyBookShelfInfo() {
            updateUI(with: cachedData)
        }
    }
    
    private func setLayout() {
        
        view.addSubviews(naviBar, containerScrollView)
        containerScrollView.addSubviews(friendsListContainerView, introProfileView, pickContainerView)
        
        friendsListContainerView.addSubviews(myProfileView, verticalLine, friendsCollectionView, horizontalLine1, horizontalLine2, emptyFriendsListDescriptionLabel)
        myProfileView.addSubviews(myProfileImageView, myNameLabel)
        introProfileView.addSubviews(introNameLabel, introductionLabel, moreButton, doubleheaderLine, doubleBottomLine)
        pickContainerView.addSubviews(pickLabel, editOrRecommendButton, pickCollectionView, emptyPickView)
        
        emptyPickView.addSubview(emptyPickViewDescriptionLabel)
        
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
        
        emptyFriendsListDescriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(verticalLine.snp.trailing).offset(30.adjusted)
            $0.centerY.equalToSuperview()
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
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        introductionLabel.snp.makeConstraints {
            $0.leading.equalTo(introNameLabel.snp.trailing).offset(28)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(12)
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
        
        emptyPickView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(70)
        }
        
        emptyPickViewDescriptionLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        checkSmallLayout()
        
        friendsCollectionView.layoutIfNeeded()
        pickCollectionView.layoutIfNeeded()
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
        
        bottomShelfVC.view.frame = CGRect(x: 0,
                                          y: view.frame.maxY,
                                          width: view.frame.width,
                                          height: view.frame.height)
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
    
    private func checkEmptyPickView(description: String, bool: Bool) {
        emptyPickView.isHidden = !bool
        pickCollectionView.isHidden = bool
        emptyPickViewDescriptionLabel.isHidden = !bool
        emptyPickViewDescriptionLabel.text = description
    }
    
    private func checkEmptyFriendListView(isEnabled: Bool) {
        self.emptyFriendsListDescriptionLabel.isHidden = !isEnabled
        self.friendsCollectionView.isHidden = isEnabled
        if isEnabled {
            emptyFriendsListDescriptionLabel.text = I18N.BookShelf.emptyFriendListDescription
        }
    }
    
    private func editPickButtonState(with bool: Bool) {        
        self.editOrRecommendButton.isEnabled = !bool
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
    
    func scrollToTop() {
        let bottomShelfVC = bottomShelfVC
        if bottomShelfVC.checkBottomShelfUp(y: bottomShelfVC.view.frame.minY) == true {
            print("바텀시트가 올라가있어서 내릴게요")
        } else {
            print("바텀시트가 이미 내려가있슴니다")
        }
        selectedUserIndex = nil
        
        let contentOffset = CGPoint(x: 0, y: 0)
        pickCollectionView.setContentOffset(contentOffset, animated: true)
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
            if bookShelfType == .user {
                bookDetailVC.changeUserViewLayout()
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
        BookShelfAPI(viewController: self).getMyBookShelfInfo { response in
            guard let data = response?.data else { return }
            
            // 데이터 캐싱
            UserDefaults.standard.setMyBookShelfInfo(data)
            
            self.serverMyBookShelfInfo = data
            self.myProfileImageView.loadProfileImage(from: data.myIntro.profileImage)
            self.myNameLabel.text = data.myIntro.nickname
            self.introNameLabel.text = data.myIntro.nickname
            self.introductionLabel.text = data.myIntro.intro
            self.friends = data.friendList
            self.picks = data.picks
            self.bottomShelfVC.setData(books: data.books, bookTotalNum: data.bookTotalNum)
            UserDefaultKeyList.userNickname = data.myIntro.nickname
            UserDefaultKeyList.userIntro = data.myIntro.intro
            UserDefaultKeyList.userProfileImage = URL(string: data.myIntro.profileImage ?? "") != nil ? data.myIntro.profileImage : ""
            
            DispatchQueue.main.async {
                self.checkEmptyFriendListView(isEnabled: data.friendList.isEmpty)
                self.checkEmptyPickView(description: I18N.BookShelf.emptyPickViewDescription, bool: data.picks.isEmpty)
                self.editPickButtonState(with: data.books.isEmpty)
                self.bottomShelfVC.setEmptyLayout(data.books.isEmpty)
                self.friendsCollectionView.reloadData()
                self.pickCollectionView.reloadData()
            }
        }
    }

    private func getFriendBookShelfInfo(userId: Int) {
        BookShelfAPI(viewController: self).getFriendBookShelfInfo(friendId: userId) { response in
            self.serverFriendBookShelfInfo = response?.data
            guard let response = response, let data = response.data else { return }
            
            self.introNameLabel.text = data.friendIntro.nickname
            self.introductionLabel.text = data.friendIntro.intro
            self.picks = data.picks
            self.bottomShelfVC.setData(books: data.books, bookTotalNum: data.bookTotalNum)
            
            DispatchQueue.main.async {
                self.checkEmptyPickView(description: I18N.BookShelf.emptyFriendPickDescription, bool: data.picks.isEmpty)
                self.bottomShelfVC.setEmptyLayout(data.books.isEmpty)
                self.pickCollectionView.reloadData()
            }
        }
    }
    
    private func deleteFollowAPI(friendId: Int) {
        FriendAPI(viewController: self).deleteFollowing(id: friendId) { response in
            if response?.success == true {
                self.isFollowingStatus = false
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct BookShelfVCPrevieew: PreviewProvider {
    static var previews: some View {
        BookShelfVC().toPreview()
    }
}
#endif
