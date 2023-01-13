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
            } else {
                getFriendBookShelfInfo(userId: friends[selectedUserIndex ?? 0].id)
                bookShelfType = .friend
            }
        }
    }
    
    // MARK: - UI Components
    
    private let bottomShelfVC = BottomBookShelfVC()

    private let containerScrollView = UIScrollView()
    private let naviContainerView = UIView()
    private let friendsListContainerView = UIView()
    private let introProfileView = UIView()
    private let pickContainerView = UIView()
    
    private let myProfileView = UIView()
    private let horizontalLine1 = UIView()
    private let horizontalLine2 = UIView()
    private let verticalLine = UIView()
    private let doubleheaderLine = DoubleHeaderLineView()
    private let doubleBottomLine = DoubleBottomLineView()
    
    private let logoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = ImageLiterals.Image.logo
        $0.clipsToBounds = true
    }
    
    private lazy var addFriendButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.friend, for: .normal)
        $0.addTarget(self, action: #selector(addFriendButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var notificationButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.notification, for: .normal)
        $0.addTarget(self, action: #selector(notiButtonDidTap), for: .touchUpInside)
    }
    
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
    private func addFriendButtonDidTap() {
        let userSearchVC = UserSearchVC()
        userSearchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(userSearchVC, animated: true)
    }
    
    @objc
    private func notiButtonDidTap() {
        let notiVC = MyNotificationVC()
        notiVC.modalPresentationStyle = .fullScreen
        present(notiVC, animated: true)
    }
    
    @objc
    private func editOrRecommendButtonDidTap() {
        switch bookShelfType {
        case .user:
            let editPickVC = EditMyPickVC()
            editPickVC.hidesBottomBarWhenPushed = true
            editPickVC.pickCount = picks.count
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
    
    @objc private func myProfileViewDidTap() {
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
        view.addSubviews(naviContainerView, containerScrollView)
        naviContainerView.addSubviews(logoImage, notificationButton, addFriendButton, horizontalLine1)
        containerScrollView.addSubviews(friendsListContainerView, introProfileView, pickContainerView)
        
        friendsListContainerView.addSubviews(myProfileView, verticalLine, friendsCollectionView, horizontalLine2)
        myProfileView.addSubviews(myProfileImageView, myNameLabel)
        
        introProfileView.addSubviews(introNameLabel, introductionLabel, doubleheaderLine, doubleBottomLine)
        
        pickContainerView.addSubviews(pickLabel, editOrRecommendButton, pickCollectionView, emptyView)
        
        emptyView.addSubview(emptyPickViewDescription)
        
        naviContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        containerScrollView.snp.makeConstraints { make in
            make.top.equalTo(naviContainerView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().inset(200.adjustedH)
        }
        
        friendsListContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(86)
        }
        
        introProfileView.snp.makeConstraints { make in
            make.top.equalTo(friendsListContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        
        pickContainerView.snp.makeConstraints { make in
            make.top.equalTo(introProfileView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        notificationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
        
        addFriendButton.snp.makeConstraints { make in
            make.trailing.equalTo(notificationButton.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        horizontalLine1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        myProfileView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(84)
        }
        
        myProfileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        myNameLabel.snp.makeConstraints { make in
            make.top.equalTo(myProfileImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        verticalLine.snp.makeConstraints { make in
            make.leading.equalTo(myProfileView.snp.trailing)
            make.centerY.equalToSuperview()
            make.width.equalTo(1)
            make.height.equalTo(62)
        }
        
        friendsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(verticalLine.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(84)
        }
        
        horizontalLine2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        doubleheaderLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        introNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        
        introductionLabel.snp.makeConstraints { make in
            make.leading.equalTo(introNameLabel.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        doubleBottomLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        pickLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.leading.equalToSuperview().offset(20)
        }
        
        editOrRecommendButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        pickCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pickLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(250)
        }
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(70)
        }
        
        emptyPickViewDescription.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension BookShelfVC {
    
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
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BookShelfVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == friendsCollectionView {
            return friends.count
        }
        
        if collectionView == pickCollectionView {
            return picks.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == friendsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCVC.className, for: indexPath)
                    as? FriendsCVC else { return UICollectionViewCell() }
            cell.setData(model: friends[indexPath.row])
            
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
            cell.setData(model: picks[indexPath.row])
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
            bookDetailVC.selectedBookIndex = picks[indexPath.row].id
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
            return CGSize(width: 60, height: 84)
        }
        
        if collectionView == pickCollectionView {
            return CGSize(width: 145, height: 250)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == friendsCollectionView {
            return -5
        }
        if collectionView == pickCollectionView {
            return 16
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
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
