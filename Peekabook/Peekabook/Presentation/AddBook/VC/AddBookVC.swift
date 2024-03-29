//
//  AddBookVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

enum SearchType: CaseIterable {
    case camera
    case text
}

final class AddBookVC: UIViewController {
    // MARK: - Properties
    
    private let placeholderBlank: String = "          "
    var bookInfo: [BookInfoModel] = []
    var searchType: SearchType = .text
    private var focus = 0
    var imgaeUrl: String = ""
    var publisher: String = ""
    
    private var serverAddBookInfo: PostBookRequest?
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton)
        .addMiddleLabel(title: I18N.BookAdd.title)
        .addRightButton(with: I18N.BookAdd.done)
        .addRightButtonAction {
            self.checkButtonDidTap()
        }
        .addLeftButtonAction {
            self.backButtonDidTap()
        }
    
    private let containerView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let bookImgView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleAspectFit
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    private let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .h3
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let authorLabel = UILabel().then {
        $0.font = .h2
        $0.textAlignment = .center
        $0.textColor = .peekaRed
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let peekaCommentView = CustomTextView()
    private let peekaMemoView = CustomTextView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomView()
        setBackgroundColor()
        setLayout()
        addTapGesture()
        addKeyboardObserver()
        // 항상 중복 확인
        checkDuplicate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout

extension AddBookVC {
    private func setCustomView() {
        peekaCommentView.updateTextView(type: .addBookComment)
        peekaMemoView.updateTextView(type: .addBookMemo)
    }
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        
        containerView.backgroundColor = .clear
    }
    
    private func setLayout() {
        [containerView, naviBar].forEach {
            view.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, peekaCommentView, peekaMemoView].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(99)
            $0.height.equalTo(160)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(bookImgView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(316)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(316)
        }
        
        peekaCommentView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.height.equalTo(229)
        }
        
        peekaMemoView.snp.makeConstraints {
            $0.top.equalTo(peekaCommentView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.height.equalTo(101)
            $0.bottom.equalToSuperview().inset(36)
        }
    }
}

// MARK: - Methods

extension AddBookVC {
    @objc private func backButtonDidTap() {
        switch searchType {
        case .camera:
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case .text:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // 완료 버튼 누르면 항상 post
    @objc private func checkButtonDidTap() {
        postCurrentBook()
    }
    
    // 책 중복 확인하는 함수
    @objc func checkDuplicate() {
        guard let bookTitle = self.nameLabel.text,
              let author = self.authorLabel.text,
              let description = (peekaCommentView.text == I18N.BookDetail.commentPlaceholder + placeholderBlank) ? "" : peekaCommentView.text,
              let memo = (peekaMemoView.text == I18N.BookDetail.memoPlaceholder + placeholderBlank) ? "" : peekaMemoView.text else { return }
        
        let checkBookDuplicated = CheckBookDuplicateRequest(bookTitle: bookTitle, author: author, publisher: self.publisher)
        checkBookDuplicateComplete(param: checkBookDuplicated)
    }
    
    @objc func postCurrentBook() {
        guard let bookTitle = self.nameLabel.text,
              let author = self.authorLabel.text,
              let description = (peekaCommentView.text == I18N.BookDetail.commentPlaceholder + placeholderBlank) ? "" : peekaCommentView.text,
              let memo = (peekaMemoView.text == I18N.BookDetail.memoPlaceholder + placeholderBlank) ? "" : peekaMemoView.text else { return }
              
        postMyBook(param: PostBookRequest(bookImage: imgaeUrl,
                                          bookTitle: bookTitle,
                                          author: author,
                                          publisher: self.publisher,
                                          description: description,
                                          memo: memo))
    }
    
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
        containerView.contentInset = contentInset
        containerView.scrollIndicatorInsets = contentInset
        
        if peekaCommentView.isTextViewFirstResponder() {
            let position = peekaCommentView.getPositionForKeyboard(keyboardFrame: keyboardFrame)
            containerView.setContentOffset(position, animated: true)
            return
        }
        
        if peekaMemoView.isTextViewFirstResponder() {
            var position = peekaMemoView.getPositionForKeyboard(keyboardFrame: keyboardFrame)
            position.y += 250
            containerView.setContentOffset(position, animated: true)
            return
        }
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerView.contentInset = contentInset
        containerView.scrollIndicatorInsets = contentInset
    }
    
    func dataBind(model: BookInfoModel) {
        nameLabel.text = model.title
        authorLabel.text = model.author.replacingOccurrences(of: "^", with: ", ")
        imgaeUrl = model.image
        publisher = model.publisher
        bookImgView.kf.indicatorType = .activity
        bookImgView.kf.setImage(with: URL(string: imgaeUrl)!)
    }
}

// MARK: - Network

extension AddBookVC {
    private func postMyBook(param: PostBookRequest) {
        BookShelfAPI(viewController: self).postMyBookInfo(param: param) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
    
    func checkBookDuplicateComplete(param: CheckBookDuplicateRequest) {
        BookShelfAPI(viewController: self).checkBookDuplicate(param: param) { response in
            if response?.success == true {
                if response?.data?.isDuplicate == true { // 중복일때
                    let vc = BookDuplicatePopUpVC()
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false)
                }
            }
        }
    }
}
