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

@frozen
private enum BookDetailMode {
    case show
    case edit
}

final class BookDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private var mode: BookDetailMode = .show {
        didSet {
            updateViewBasedOnMode(.show)
        }
    }
    
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
        setShowModeTextView()
        setBackgroundColor()
        setLayout()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBookData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
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
            $0.bottom.equalToSuperview().inset(25)
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
    
    private func setShowModeTextView() {
        peekaCommentView.changeBackgroundColor(with: .clear)
        peekaMemoView.changeBackgroundColor(with: .clear)
        peekaCommentView.updateTextView(type: .bookDetailComment)
        peekaMemoView.updateTextView(type: .bookDetailMemo)
    }
    
    private func getBookData() {
        getBookDetail(id: selectedBookIndex)
    }
    
    private func setCommentColor() {
        
        guard let descriptions = peekaCommentView.text,
              let memo = peekaMemoView.text else { return }
        
        if mode == .edit {
            if descriptions.isEmpty || peekaCommentView.text == I18N.BookDetail.commentPlaceholder + placeholderBlank {
                peekaCommentView.text = I18N.BookDetail.commentPlaceholder + placeholderBlank
                peekaCommentView.setTextColor(.peekaGray2)
            } else {
                peekaCommentView.setTextCustomMaxLabel("\(descriptions.count)/200")
            }
            
            if memo.isEmpty || peekaMemoView.text == I18N.BookDetail.memoPlaceholder + placeholderBlank {
                peekaMemoView.text = I18N.BookDetail.memoPlaceholder + placeholderBlank
                peekaMemoView.setTextColor(.peekaGray2)
            } else {
                peekaMemoView.setTextCustomMaxLabel("\(memo.count)/50")
            }
            
        } else { // mode == .show
            if descriptions.isEmpty || peekaCommentView.text == I18N.BookDetail.commentPlaceholder + placeholderBlank {
                peekaCommentView.setTextColor(.peekaGray2)
                peekaCommentView.text = I18N.BookDetail.emptyComment
            } else {
                peekaCommentView.setTextColor(.peekaRed)
            }
            
            if memo.isEmpty || peekaMemoView.text == I18N.BookDetail.memoPlaceholder + placeholderBlank {
                peekaMemoView.setTextColor(.peekaGray2)
                peekaMemoView.text = I18N.BookDetail.emptyMemo
            } else {
                peekaMemoView.setTextColor(.peekaRed)
            }
        }
    }
    
    private func updateViewBasedOnMode(_ mode: BookDetailMode) {
        switch mode {
        case .show:
            peekaCommentView.textView.isEditable = false
            peekaMemoView.textView.isEditable = false

            naviBar.removeFromSuperview()
            naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithTwoRightButtons)
            naviBar.addRightButton(with: ImageLiterals.Icn.delete!)
                .addOtherRightButton(with: ImageLiterals.Icn.edit!)
                .addRightButtonAction {
                    self.deleteButtonDidTap()
                } .addOtherRightButtonAction {
                    self.editButtonDidTap()
                }
            view.addSubview(naviBar)
            setNaviBarConstraints()
            setShowModeTextView()
            
            peekaMemoView.snp.updateConstraints {
                $0.top.equalTo(peekaCommentView.snp.bottom).offset(12)
            }

        case .edit:

            peekaCommentView.textView.isEditable = true
            peekaMemoView.textView.isEditable = true

            naviBar.removeFromSuperview()
            naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton)
            naviBar.changeLeftBackButtonToXmark()
                .addMiddleLabel(title: I18N.BookEdit.title)
                .addLeftButtonAction {
                    self.cancelEditButtonDidTap()
                }
                .addRightButton(with: I18N.BookEdit.done)
                .addRightButtonAction {
                    self.completeEditButtonDidTap()
                }
            view.addSubview(naviBar)
            setNaviBarConstraints()
            
            peekaMemoView.snp.updateConstraints {
                $0.top.equalTo(peekaCommentView.snp.bottom).offset(40)
            }
            
            let tapGestureComment = UITapGestureRecognizer(target: self, action: #selector(commentViewTapped))
            let tapGestureMemo = UITapGestureRecognizer(target: self, action: #selector(memoViewTapped))
            peekaCommentView.addGestureRecognizer(tapGestureComment)
            peekaMemoView.addGestureRecognizer(tapGestureMemo)

            setEditModeTextView()
        }
    }

    private func setNaviBarConstraints() {
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func commentViewTapped() {
        peekaCommentView.textView.becomeFirstResponder()
    }
    
    @objc func memoViewTapped() {
        peekaMemoView.textView.becomeFirstResponder()
    }
    
    private func setEditModeTextView() {
        peekaCommentView.updateTextView(type: .editBookComment)
        peekaMemoView.updateTextView(type: .editBookMemo)
        peekaCommentView.changeBackgroundColor(with: .peekaWhite_60)
        peekaMemoView.changeBackgroundColor(with: .peekaWhite_60)
        
        guard let descriptions = peekaCommentView.text,
              let memo = peekaMemoView.text else { return }
            
        if descriptions.isEmpty || descriptions == I18N.BookDetail.commentPlaceholder + placeholderBlank {
            peekaMemoView.setTextCustomMaxLabel(I18N.BookAdd.commentLength)
        } else {
            peekaMemoView.setTextCustomMaxLabel("\(descriptions.count)/200")
        }
        
        if memo.isEmpty || memo == I18N.BookDetail.memoPlaceholder + placeholderBlank {
            peekaMemoView.setTextCustomMaxLabel(I18N.BookAdd.memoLength)
        } else {
            peekaMemoView.setTextCustomMaxLabel("\(memo.count)/50")
        }
    }

    // MARK: - @objc Function
    
    @objc
    private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func editButtonDidTap() {
        switch mode {
        case .show:
            mode = .edit
            updateViewBasedOnMode(.edit)
            getBookData()
        case .edit:
            mode = .show
            updateViewBasedOnMode(.show)
        }
    }
    
    @objc
    private func deleteButtonDidTap() {
        let popupViewController = DeletePopUpVC()
        popupViewController.bookShelfId = self.selectedBookIndex
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)
    }
    
    @objc
    private func cancelEditButtonDidTap() {
        mode = .show
        updateViewBasedOnMode(.show)
        getBookData()
    }
    
    @objc
    private func completeEditButtonDidTap() {
        guard let description = (peekaCommentView.text == I18N.BookDetail.commentPlaceholder + placeholderBlank) || (peekaCommentView.text == I18N.BookDetail.emptyComment) ? "" : peekaCommentView.text,
              let memo = (peekaMemoView.text == I18N.BookDetail.memoPlaceholder + placeholderBlank) || (peekaMemoView.text == I18N.BookDetail.emptyMemo) ? "" : peekaMemoView.text else { return }
        
        editMyBookInfo(id: selectedBookIndex, param: EditBookRequest(description: description, memo: memo))
    }
    
}

// MARK: - Keyboard handling

extension BookDetailVC {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        containerScrollView.contentInset = contentInset
        containerScrollView.scrollIndicatorInsets = contentInset
        
        if peekaCommentView.isTextViewFirstResponder() {
            let position = peekaCommentView.getPositionForKeyboard(keyboardFrame: keyboardFrame)
            containerScrollView.setContentOffset(position, animated: true)
            return
        }
        
        if peekaMemoView.isTextViewFirstResponder() {
            var position = peekaMemoView.getPositionForKeyboard(keyboardFrame: keyboardFrame)
            position.y += 250
            containerScrollView.setContentOffset(position, animated: true)
            return
        }
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerScrollView.contentInset = contentInset
        containerScrollView.scrollIndicatorInsets = contentInset
    }
}

// MARK: - Network

extension BookDetailVC {
    func getBookDetail(id: Int) {
        BookShelfAPI(viewController: self).getBookDetail(id: id) { response in
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
    
    func editMyBookInfo(id: Int, param: EditBookRequest) {
        BookShelfAPI(viewController: self).editMyBookInfo(id: id, param: param) { response in
            if response?.success == true {
                self.mode = .show
                self.updateViewBasedOnMode(.show)
                self.getBookData()
            }
        }
    }
}
