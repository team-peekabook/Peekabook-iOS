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
    
    private let headerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    private let headerTitleLabel = UILabel().then {
        $0.text = I18N.BookEdit.title
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private lazy var checkButton = UIButton().then {
        $0.setTitle(I18N.BookEdit.done, for: .normal)
        $0.titleLabel!.font = .h4
        $0.setTitleColor(.peekaRed, for: .normal)
        $0.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }
    
    private let containerView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var bookImgView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleAspectFit
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    var nameLabel = UILabel().then {
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    var authorLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed
    }
    
    private let commentBoxView = UIView()
    private let commentHeaderView = UIView()
    
    private let commentLabel = UILabel().then {
        $0.text = I18N.BookDetail.comment
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    private let commentTextView = UITextView().then {
        $0.text = I18N.BookDetail.commentHint
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.backgroundColor = .clear
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
        $0.returnKeyType = .done
    }
    
    private lazy var commentMaxLabel = UILabel().then {
        $0.text = "\(descriptions.count)/200"
        $0.font = .h2
        $0.textColor = .peekaGray2
    }
    
    private let memoBoxView = UIView()
    private let memoHeaderView = UIView()
    
    private let memoLabel = UILabel().then {
        $0.text = I18N.BookDetail.memo
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    private let memoTextView = UITextView().then {
        $0.text = I18N.BookDetail.memoHint
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.backgroundColor = .clear
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
        $0.returnKeyType = .done
    }
    
    private lazy var memoMaxLabel = UILabel().then {
        $0.text = "\(memo.count)/50"
        $0.font = .h2
        $0.textColor = .peekaGray2
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        addTapGesture()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commentTextView.text = descriptions
        memoTextView.text = memo
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout
extension EditBookVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        commentBoxView.backgroundColor = .peekaBeige
        commentBoxView.layer.borderWidth = 2
        commentBoxView.layer.borderColor = UIColor.peekaRed.cgColor
        commentHeaderView.backgroundColor = .peekaRed
        
        memoBoxView.backgroundColor = .peekaBeige
        memoBoxView.layer.borderWidth = 2
        memoBoxView.layer.borderColor = UIColor.peekaRed.cgColor
        memoHeaderView.backgroundColor = .peekaRed
        
        backButton.setImage(ImageLiterals.Icn.back, for: .normal)
    }
    
    private func setLayout() {
        [containerView, headerView].forEach {
            view.addSubview($0)
        }
        
        [backButton, headerTitleLabel, checkButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, commentBoxView, commentMaxLabel, memoBoxView, memoMaxLabel].forEach {
            containerView.addSubview($0)
        }
        
        [commentHeaderView, commentTextView].forEach {
            commentBoxView.addSubview($0)
        }
        
        [commentLabel].forEach {
            commentHeaderView.addSubview($0)
        }
        
        [memoHeaderView, memoTextView].forEach {
            memoBoxView.addSubview($0)
        }
        
        [memoLabel].forEach {
            memoHeaderView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(11)
            make.width.height.equalTo(48)
        }
        
        bookImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImgView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        commentBoxView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
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
            make.leading.trailing.bottom.equalTo(commentBoxView).inset(14)
        }
        
        commentMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(commentBoxView.snp.bottom).offset(8)
            make.trailing.equalTo(commentBoxView.snp.trailing)
        }
        
        memoBoxView.snp.makeConstraints { make in
            make.top.equalTo(commentMaxLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
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
            make.leading.trailing.bottom.equalTo(memoBoxView).inset(14)
        }
        
        memoMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(memoBoxView.snp.bottom).offset(8)
            make.trailing.equalTo(memoBoxView.snp.trailing)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}

// MARK: - Methods

extension EditBookVC {
    private func setDelegate() {
        commentTextView.delegate = self
        memoTextView.delegate = self
    }
    
    @objc private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func checkButtonDidTap() {
        print("checkButtonDidTap")
        editMyBookInfo(id: bookIndex, param: EditBookRequest(description: commentTextView.text, memo: memoTextView.text))
        let vc = BookDetailVC()
        vc.getBookDetail(id: bookIndex)
    }
    
    private func config() {
        backButton.setImage(ImageLiterals.Icn.back, for: .normal)
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
        
        if commentTextView.isFirstResponder {
            let textViewHeight = commentBoxView.frame.height
            let position = CGPoint(x: 0, y: commentBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight - 36)
            containerView.setContentOffset(position, animated: true)
            return
        }
        
        if memoTextView.isFirstResponder {
            let textViewHeight = memoBoxView.frame.height
            let position = CGPoint(x: 0, y: memoBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight - 36)
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

extension EditBookVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == commentTextView {
            commentMaxLabel.text = "\(commentTextView.text.count)/200"
            if commentTextView.text.count > 200 {
                commentTextView.deleteBackward()
            }
        }
        
        if textView == memoTextView {
            memoMaxLabel.text = "\(memoTextView.text.count)/50"
            if memoTextView.text.count > 50 {
                memoTextView.deleteBackward()
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == I18N.BookDetail.emptyComment {
            textView.text = nil
            textView.textColor = .peekaRed
        } else if textView.text == I18N.BookDetail.emptyMemo {
            textView.text = nil
            textView.textColor = .peekaRed
        }
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            commentTextView.text = I18N.BookDetail.commentHint
            commentTextView.textColor = .peekaGray1
        } else if memoTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            memoTextView.text = I18N.BookDetail.memoHint
            memoTextView.textColor = .peekaGray1
        }
    }
}
