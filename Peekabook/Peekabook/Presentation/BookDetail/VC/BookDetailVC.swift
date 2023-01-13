//
//  BookDetailVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class BookDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private var serverWatchBookDetail: WatchBookDetailResponse?
    var selectedBookIndex: Int = 0

    // MARK: - UI Components
    
    private let naviContainerView = UIView()
    private let containerScrollView = UIScrollView()
    private let commentContainerView = UIView()
    private let commentHeaderView = UIView()
    private let memoContainerView = UIView()
    private let memoHeaderView = UIView()
    
    private lazy var backButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.back, for: .normal)
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var editButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.edit, for: .normal)
        $0.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var deleteButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.delete, for: .normal)
        $0.addTarget(self, action: #selector(deleteButtonDidTap), for: .touchUpInside)
    }
    
    private var bookImageView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleToFill
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    private var bookNameLabel = UILabel().then {
        $0.font = .h3
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private var bookAuthorLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed
    }
    
    private let commentLabel = UILabel().then {
        $0.text = I18N.BookDetail.comment
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    private let commentTextView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
    }
    
    private let memoLabel = UILabel().then {
        $0.text = I18N.BookDetail.memo
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    private lazy var memoTextView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUI()
        setLayout()
        getBookDetail(id: selectedBookIndex)
    }
    
    // MARK: - @objc Function
    @objc
    private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func editButtonDidTap() {
        let editVC = EditBookVC()
        editVC.bookImgView = bookImageView
        editVC.nameLabel = bookNameLabel
        editVC.authorLabel = bookAuthorLabel
        editVC.descriptions = commentTextView.text
        editVC.memo = memoTextView.text
        editVC.bookIndex = selectedBookIndex
        
        editVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc
    private func deleteButtonDidTap() {
        let popupViewController = DeletePopUpVC()
        popupViewController.bookShelfId = self.selectedBookIndex
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)
    }
}

// MARK: - UI & Layout
extension BookDetailVC {
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
        
        commentContainerView.layer.borderWidth = 2
        commentContainerView.layer.borderColor = UIColor.peekaRed.cgColor
        commentHeaderView.backgroundColor = .peekaRed
        
        memoContainerView.layer.borderWidth = 2
        memoContainerView.layer.borderColor = UIColor.peekaRed.cgColor
        memoHeaderView.backgroundColor = .peekaRed
        
        containerScrollView.showsVerticalScrollIndicator = false
    }
    
    private func setLayout() {
        view.addSubviews(naviContainerView, containerScrollView)
        naviContainerView.addSubviews(backButton, deleteButton, editButton)
        
        containerScrollView.addSubviews(bookImageView, bookNameLabel, bookAuthorLabel, commentContainerView, memoContainerView)
        
        commentContainerView.addSubviews(commentHeaderView, commentTextView)
        commentHeaderView.addSubview(commentLabel)
        
        memoContainerView.addSubviews(memoHeaderView, memoTextView)
        memoHeaderView.addSubview(memoLabel)
        
        naviContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteButton.snp.leading)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        containerScrollView.snp.makeConstraints { make in
            make.top.equalTo(naviContainerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(160)
        }
        
        bookNameLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        bookAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(bookNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        commentContainerView.snp.makeConstraints { make in
            make.top.equalTo(bookAuthorLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(230)
        }
        
        commentHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(36)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(commentHeaderView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(170)
        }
        
        memoContainerView.snp.makeConstraints { make in
            make.top.equalTo(commentContainerView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(100)
        }
        
        memoHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(36)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.top.equalTo(memoHeaderView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(40)
        }
    }
}

// MARK: - Methods

extension BookDetailVC {
    func changeUserViewLayout() {
        self.editButton.isHidden = false
        self.deleteButton.isHidden = false
    }
    
    func changeFriendViewLayout() {
        self.editButton.isHidden = true
        self.deleteButton.isHidden = true
    }
    
    private func setEmptyView() {
        if commentTextView.text.isEmpty == true {
            commentTextView.textColor = .peekaGray2
            commentTextView.text = I18N.BookDetail.emptyComment
        } else {
            commentTextView.textColor = .peekaRed
        }
        
        if memoTextView.text.isEmpty == true {
            memoTextView.textColor = .peekaGray2
            memoTextView.text = I18N.BookDetail.emptyComment
        } else {
            memoTextView.textColor = .peekaRed
        }
    }
}

// MARK: - Network

extension BookDetailVC {
    func getBookDetail(id: Int) {
        BookShelfAPI.shared.getBookDetail(id: id) { response in
            guard let serverWatchBookDetail = response?.data else { return }
            self.bookImageView.kf.indicatorType = .activity
            self.bookImageView.kf.setImage(with: URL(string: serverWatchBookDetail.book.bookImage))
            self.bookNameLabel.text = serverWatchBookDetail.book.bookTitle
            self.bookAuthorLabel.text = serverWatchBookDetail.book.author
            self.commentTextView.text = serverWatchBookDetail.description
            self.memoTextView.text = serverWatchBookDetail.memo
            self.selectedBookIndex = id
            self.setEmptyView()
        }
    }
}
