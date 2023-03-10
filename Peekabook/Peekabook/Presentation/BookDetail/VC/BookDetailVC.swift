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
    private let containerScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let peekaCommentView = CustomTextView()
    private let peekaMemoView = CustomTextView()
    
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
    
    private let bookImageView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleToFill
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    private let bookNameLabel = UILabel().then {
        $0.font = .h3
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let bookAuthorLabel = UILabel().then {
        $0.font = .h2
        $0.textAlignment = .center
        $0.textColor = .peekaRed
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomView()
        setBackgroundColor()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCustomView()
        setBackgroundColor()
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
        editVC.setBookImgView(bookImageView)
        editVC.setNameLabel(bookNameLabel)
        editVC.setAuthorLabel(bookAuthorLabel)
        editVC.descriptions = peekaCommentView.getTextView().text
        editVC.memo = peekaMemoView.getTextView().text
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
    
    private func setCustomView() {
        peekaCommentView.updateBookDetailCommentTextView()
        peekaMemoView.updateBookDetailMemoTextView()
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(naviContainerView, containerScrollView)
        naviContainerView.addSubviews(backButton, deleteButton, editButton)
        
        containerScrollView.addSubviews(bookImageView, bookNameLabel, bookAuthorLabel, peekaCommentView, peekaMemoView)
        
        naviContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalTo(deleteButton.snp.leading)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(naviContainerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(160)
        }
        
        bookNameLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(316)
        }
        
        bookAuthorLabel.snp.makeConstraints {
            $0.top.equalTo(bookNameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(316)
        }
        
        peekaCommentView.snp.makeConstraints {
            $0.top.equalTo(bookAuthorLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(230)
        }
        
        peekaMemoView.snp.makeConstraints {
            $0.top.equalTo(peekaCommentView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(15)
            $0.height.equalTo(101)
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
    
    private func setCommentColor() {
        if (peekaCommentView.getTextView().text == I18N.BookDetail.commentPlaceholder + "           ")
            || (peekaCommentView.getTextView().text == I18N.BookDetail.emptyComment)
            || (peekaCommentView.getTextView().text.isEmpty == true) {
            peekaCommentView.getTextView().textColor = .peekaGray2
            peekaCommentView.getTextView().text = I18N.BookDetail.emptyComment
        } else {
            peekaCommentView.getTextView().textColor = .peekaRed
        }
            
        if (peekaMemoView.getTextView().text == I18N.BookDetail.memoPlaceholder)
            || (peekaMemoView.getTextView().text == I18N.BookDetail.emptyMemo)
            || (peekaMemoView.getTextView().text.isEmpty == true) {
            peekaMemoView.getTextView().textColor = .peekaGray2
            peekaMemoView.getTextView().text = I18N.BookDetail.emptyMemo
        } else {
            peekaMemoView.getTextView().textColor = .peekaRed
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
            self.peekaCommentView.getTextView().text = serverWatchBookDetail.description
            self.peekaMemoView.getTextView().text = serverWatchBookDetail.memo
            self.selectedBookIndex = id
            self.setCommentColor()
        }
    }
}
