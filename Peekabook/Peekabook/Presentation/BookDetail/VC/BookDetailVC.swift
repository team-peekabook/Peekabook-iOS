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
    
    private let placeholderBlank: String = "          "
    private var serverWatchBookDetail: WatchBookDetailResponse?
    var selectedBookIndex: Int = 0
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithTwoRightButtons)
    
    private let containerScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let peekaCommentView = CustomTextView()
    private let peekaMemoView = CustomTextView()
    
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
        getBookData()
    }
}

// MARK: - UI & Layout
extension BookDetailVC {
    
    private func setBackgroundColor() {
        view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, containerScrollView)
        
        containerScrollView.addSubviews(bookImageView, bookNameLabel, bookAuthorLabel, peekaCommentView, peekaMemoView)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
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
        naviBar.addRightButton(with: ImageLiterals.Icn.delete!)
            .addOtherRightButton(with: ImageLiterals.Icn.edit!)
            .addRightButtonAction {
                self.deleteButtonDidTap()
            } .addOtherRightButtonAction {
                self.editButtonDidTap()
            }
    }
    
    private func setCustomView() {
        peekaCommentView.updateTextView(type: .bookDetailComment)
        peekaMemoView.updateTextView(type: .bookDetailMemo)
    }
    
    private func getBookData() {
        getBookDetail(id: selectedBookIndex)
    }
    
    private func setCommentColor() {
        if let text = peekaCommentView.text,
           (text == I18N.BookDetail.commentPlaceholder + placeholderBlank)
            || (text == I18N.BookDetail.emptyComment)
            || (text.isEmpty) {
            peekaCommentView.setTextColor(.peekaGray2)
            peekaCommentView.text = I18N.BookDetail.emptyComment
        } else {
            peekaCommentView.setTextColor(.peekaRed)
        }
        
        if let memoText = peekaMemoView.text,
           (memoText == I18N.BookDetail.memoPlaceholder + placeholderBlank)
            || (memoText == I18N.BookDetail.emptyMemo)
            || (memoText.isEmpty) {
            peekaMemoView.setTextColor(.peekaGray2)
            peekaMemoView.text = I18N.BookDetail.emptyMemo
        } else {
            peekaMemoView.setTextColor(.peekaRed)
        }
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
        editVC.descriptions = peekaCommentView.text ?? ""
        editVC.memo = peekaMemoView.text ?? ""
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
            self.peekaCommentView.text = serverWatchBookDetail.description
            self.peekaMemoView.text = serverWatchBookDetail.memo
            self.selectedBookIndex = id
            self.setCommentColor()
        }
    }
}
