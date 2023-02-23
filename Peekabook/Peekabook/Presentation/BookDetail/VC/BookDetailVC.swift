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
    private let peekaCommentView = CommentView()
    private let peekaMemoView = CommentView()
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
    
    private lazy var bookImageView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleToFill
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    private lazy var bookNameLabel = UILabel().then {
        $0.font = .h3
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private lazy var bookAuthorLabel = UILabel().then {
        $0.font = .h2
        $0.textAlignment = .center
        $0.textColor = .peekaRed
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setReusableView()
        setUI()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setReusableView()
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
        editVC.descriptions = peekaCommentView.commentTextView.text
        editVC.memo = peekaMemoView.commentTextView.text
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
    
    private func setReusableView() {
        peekaCommentView.commentBoxView.backgroundColor = .clear
        peekaCommentView.commentMaxLabel.isHidden = true
        
        peekaMemoView.commentBoxView.backgroundColor = .clear
        peekaMemoView.commentMaxLabel.isHidden = true
        peekaMemoView.commentBoxView.frame.size.height = 101
    }
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
        containerScrollView.showsVerticalScrollIndicator = false
    }
    
    private func setLayout() {
        view.addSubviews(naviContainerView, containerScrollView)
        naviContainerView.addSubviews(backButton, deleteButton, editButton)
        
        containerScrollView.addSubviews(bookImageView, bookNameLabel, bookAuthorLabel, peekaCommentView, peekaMemoView)
        
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
            make.width.equalTo(316)
        }
        
        bookAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(bookNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(316)
        }
        
        peekaCommentView.snp.makeConstraints { make in
            make.top.equalTo(bookAuthorLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(230)
        }
        
        peekaMemoView.snp.makeConstraints { make in
            make.top.equalTo(peekaCommentView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(101)
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
        if (peekaCommentView.commentTextView.text == I18N.BookDetail.commentHint) || (peekaCommentView.commentTextView.text == I18N.BookDetail.emptyComment)
            || (peekaCommentView.commentTextView.text.isEmpty == true) {
            peekaCommentView.commentTextView.textColor = .peekaGray2
            peekaCommentView.commentTextView.text = I18N.BookDetail.emptyComment
        } else {
            peekaCommentView.commentTextView.textColor = .peekaRed
        }
            
        if (peekaMemoView.commentTextView.text == I18N.BookDetail.memoHint) || (peekaMemoView.commentTextView.text == I18N.BookDetail.emptyMemo)
            || (peekaMemoView.commentTextView.text.isEmpty == true) {
            peekaMemoView.commentTextView.textColor = .peekaGray2
            peekaMemoView.commentTextView.text = I18N.BookDetail.emptyMemo
        } else {
            peekaMemoView.commentTextView.textColor = .peekaRed
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
            let bookAuthorLabelStr = serverWatchBookDetail.book.author
            self.bookAuthorLabel.text = bookAuthorLabelStr.replacingOccurrences(of: "^", with: ", ")
            self.peekaCommentView.commentTextView.text = serverWatchBookDetail.description
            self.peekaMemoView.commentTextView.text = serverWatchBookDetail.memo
            self.selectedBookIndex = id
            self.setEmptyView()
        }
    }
}
