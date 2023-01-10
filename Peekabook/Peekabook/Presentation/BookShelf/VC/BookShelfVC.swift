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

final class BookShelfVC: UIViewController {
    
    // MARK: - Properties
    
    private var serverMyBookShelfInfo: MyBookShelfResponse?
    private var friendsModelList = SampleFriendsModel.data
    private var userModel = SampleUserModel.data
    private var pickModelList = SamplePickModel.data
    
    // MARK: - UI Components
    
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let myProfileImageView = UIImageView().then {
        $0.image = ImageLiterals.Sample.profile6
        $0.contentMode = .scaleAspectFill
        $0.layer.borderColor = UIColor.peekaRed.cgColor
        $0.layer.borderWidth = 2
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 22
        $0.clipsToBounds = true
    }
    
    private let myNameLabel = UILabel().then {
        $0.text = "윤수빈"
        $0.font = .s1
        $0.textColor = .peekaRed
        $0.textAlignment = .center
    }
    
    private let introNameLabel = UILabel().then {
        $0.text = "윤수빈"
        $0.font = .nameBold
        $0.textColor = .peekaRed
        $0.textAlignment = .center
    }
    
    private let introductionLabel = UILabel().then {
        $0.text = "수빈은 윤수빈 수빈은 문수빈 수빈은 윤수빈 수빈은 문수빈 수빈은 윤수빈"
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
    
    private lazy var editPickButton = UIButton(type: .system).then {
        $0.titleLabel!.font = .c1
        $0.setTitle(I18N.BookShelf.editPick, for: .normal)
        $0.setTitleColor(.peekaRed, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.peekaRed.cgColor
        $0.addTarget(self, action: #selector(editPickButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var pickCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
    private func editPickButtonDidTap() {
        let editPickVC = EditMyPickVC()
        editPickVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editPickVC, animated: true)
    }
    
    @objc private func myProfileViewDidTap() {
        print("myProfileViewDidTap")
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
        
        editPickButton.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
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
        
        pickContainerView.addSubviews(pickLabel, editPickButton, pickCollectionView)
                
        naviContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        containerScrollView.snp.makeConstraints { make in
            make.top.equalTo(naviContainerView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
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
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
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
            make.leading.equalToSuperview()
        }
        
        editPickButton.snp.makeConstraints { make in
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
    }
}

// MARK: - Methods

extension BookShelfVC {
    
    private func addBottomSheetView(scrollable: Bool? = true) {
        let bottomShelfVC = BottomBookShelfVC()
        
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
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BookShelfVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == friendsCollectionView {
            return friendsModelList.count
        }
        
        if collectionView == pickCollectionView {
            return pickModelList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == friendsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCVC.className, for: indexPath)
                    as? FriendsCVC else { return UICollectionViewCell() }
            cell.initCell(model: friendsModelList[indexPath.row])
            return cell
        }
        
        if collectionView == pickCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickCVC.className, for: indexPath)
                    as? PickCVC else { return UICollectionViewCell() }
            cell.initCell(model: pickModelList[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == friendsCollectionView {
            print("\(indexPath.item) click")
            
        }
        
        if collectionView == pickCollectionView {
            let bookDetailVC = BookDetailVC()
            bookDetailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(bookDetailVC, animated: true)
            print("selected index is \(indexPath.row)")
        }
    }
}

// MARK: - UICollectionViewFlowLayout

extension BookShelfVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == friendsCollectionView {
            return CGSize(width: 60, height: 84)
        }
        
        if collectionView == pickCollectionView {
            return CGSize(width: 145.adjusted, height: 250)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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
    
    private func getMyBookShelfInfo(userId: String) {
        BookShelfAPI.shared.getMyBookShelfInfo { response in
            switch response {
            case .success(let data):
                if let myBookShelfInfo = data as? MyBookShelfResponse {
                    self.serverMyBookShelfInfo = myBookShelfInfo
                    // TODO:- 서버에서 받은 response 뷰에 반영하기
                    
                }
            case .requestErr(let message):
                print("latestPhotosWithAPI - requestErr: \(message)")
            case .pathErr:
                print("latestPhotosWithAPI - pathErr")
            case .serverErr:
                print("latestPhotosWithAPI - serverErr")
            case .networkFail:
                print("latestPhotosWithAPI - networkFail")
            }
        }
    }
}
