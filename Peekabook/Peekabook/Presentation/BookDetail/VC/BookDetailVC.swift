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
        editVC.descriptions = peekaCommentView.textView.text
        editVC.memo = peekaMemoView.textView.text
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
        peekaCommentView.boxView.backgroundColor = .clear
        peekaCommentView.maxLabel.isHidden = true
        
        peekaMemoView.label.text = I18N.BookDetail.memo
        peekaMemoView.boxView.backgroundColor = .clear
        peekaMemoView.maxLabel.isHidden = true
        peekaMemoView.boxView.frame.size.height = 101
    }
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
        containerScrollView.showsVerticalScrollIndicator = false
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
        if (peekaCommentView.textView.text == I18N.BookDetail.commentHint)
            || (peekaCommentView.textView.text == I18N.BookDetail.emptyComment)
            || (peekaCommentView.textView.text.isEmpty == true) {
            peekaCommentView.textView.textColor = .peekaGray2
            peekaCommentView.textView.text = I18N.BookDetail.emptyComment
        } else {
            peekaCommentView.textView.textColor = .peekaRed
        }
            
        if (peekaMemoView.textView.text == I18N.BookDetail.memoHint)
            || (peekaMemoView.textView.text == I18N.BookDetail.emptyMemo)
            || (peekaMemoView.textView.text.isEmpty == true) {
            peekaMemoView.textView.textColor = .peekaGray2
            peekaMemoView.textView.text = I18N.BookDetail.emptyMemo
        } else {
            peekaMemoView.textView.textColor = .peekaRed
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
            self.peekaCommentView.textView.text = serverWatchBookDetail.description
            self.peekaMemoView.textView.text = serverWatchBookDetail.memo
            self.selectedBookIndex = id
            self.setCommentColor()
        }
    }
}
