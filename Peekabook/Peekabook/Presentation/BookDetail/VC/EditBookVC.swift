//
//  EditBookVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/07.
//

import UIKit

import SnapKit
import Then

import Moya

final class EditBookVC: UIViewController {
    
    // MARK: - Properties
    var status: Int = 0
    private var focus = 0
    var bookIndex: Int = 0
    var descriptions: String = ""
    var memo: String = ""
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton)
        .addMiddleLabel(title: I18N.BookEdit.title)
        .addRightButton(with: I18N.BookEdit.done)
        .addRightButtonAction {
            self.checkButtonDidTap()
        }
    
    private let containerView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var bookImgView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleAspectFit
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    private var nameLabel = UILabel().then {
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private var authorLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed
    }
    
    private let peekaCommentView = CustomTextView()
    private let peekaMemoView = CustomTextView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomView()
        setBackgroundColor()
        setLayout()
        addKeyboardObserver()
        updateTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomView()
        setBackgroundColor()
        setLayout()
        loadTextData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout
extension EditBookVC {
    
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
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(bookImgView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        peekaCommentView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(229)
        }
        
        peekaMemoView.snp.makeConstraints {
            $0.top.equalTo(peekaCommentView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(101)
            $0.bottom.equalToSuperview().inset(36)
        }
    }
}

// MARK: - Methods

extension EditBookVC {
    
    private func updateTextView() {
        peekaMemoView.updateTextView(type: .editBookMemo)
        peekaCommentView.updateTextView(type: .editBookComment)
    }
    
    private func loadTextData() {
        peekaCommentView.text = descriptions
        peekaMemoView.text = memo
    }
    
    private func setCustomView() {
        
        if descriptions != I18N.BookDetail.emptyComment {
            peekaCommentView.setTextColor(.peekaRed)
            peekaCommentView.setTextCustomMaxLabel("\(descriptions.count)/200")
        } else {
            peekaCommentView.setTextCustomMaxLabel(I18N.BookAdd.commentLength)
        }
        
        if memo != I18N.BookDetail.emptyMemo {
            peekaMemoView.setTextColor(.peekaRed)
            peekaMemoView.setTextCustomMaxLabel("\(memo.count)/50")
        } else {
            peekaMemoView.setTextCustomMaxLabel(I18N.BookAdd.memoLength)
        }
    }
    
    public func setBookImgView(_ imageView: UIImageView) {
        self.bookImgView = imageView
    }
    
    public func setNameLabel(_ label: UILabel) {
        self.nameLabel = label
    }
    
    public func setAuthorLabel(_ label: UILabel) {
        self.authorLabel = label
    }
    
    @objc private func checkButtonDidTap() {
        print("checkButtonDidTap")
        editMyBookInfo(id: bookIndex, param: EditBookRequest(description: peekaCommentView.text, memo: peekaMemoView.text))
        let vc = BookDetailVC()
        vc.getBookDetail(id: bookIndex)
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
}

extension EditBookVC {
    func editMyBookInfo(id: Int, param: EditBookRequest) {
        BookShelfAPI.shared.editMyBookInfo(id: id, param: param) { response in
            if response?.success == true {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("책 수정 실패")
            }
        }
    }
}
