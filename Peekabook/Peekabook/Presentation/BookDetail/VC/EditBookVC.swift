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

    private var focus = 0

    // MARK: - UI Components
    
    private let headerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    private let headerTitle = UILabel().then {
        $0.text = I18N.BookEdit.title
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private lazy var checkButton = UIButton().then {
        $0.setTitle(I18N.BookEdit.done, for: .normal)
        $0.titleLabel!.font = .h4
        $0.setTitleColor(.peekaRed, for: .normal)
        $0.addTarget(AddBookVC.self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }
    
    private let containerView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let bookImgView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleAspectFit
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    private var nameLabel = UILabel().then {
        $0.text = "아무튼, 여름"
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private var authorLabel = UILabel().then {
        $0.text = "김신회"
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
    
    private let commentView = UITextView().then {
        $0.text = I18N.BookDetail.comment
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.backgroundColor = .clear
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
    }
    
    lazy var commentMaxLabel = UILabel().then {
        $0.text = "0/200"
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
    
    private lazy var memoView = UITextView().then {
        $0.text = I18N.BookDetail.memo
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.backgroundColor = .clear
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
    }
    
    lazy var memoMaxLabel = UILabel().then {
        $0.text = "0/50"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.registerForKeyboardNotification()
        }
    
    deinit {
        self.removeRegisterForKeyboardNotification()
    }
    
}

// MARK: - UI & Layout
extension EditBookVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        commentBoxView.backgroundColor = .peekaWhite
        commentBoxView.layer.borderWidth = 2
        commentBoxView.layer.borderColor = UIColor.peekaRed.cgColor
        commentHeaderView.backgroundColor = .peekaRed
        
        memoBoxView.backgroundColor = .peekaWhite
        memoBoxView.layer.borderWidth = 2
        memoBoxView.layer.borderColor = UIColor.peekaRed.cgColor
        memoHeaderView.backgroundColor = .peekaRed
        
        backButton.setImage(ImageLiterals.Icn.back, for: .normal)
        bookImgView.image = ImageLiterals.Sample.book1
    }
    
    private func setLayout() {
        [containerView, headerView].forEach {
            view.addSubview($0)
        }
        
        [backButton, headerTitle, checkButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, commentBoxView, commentMaxLabel, memoBoxView, memoMaxLabel].forEach {
            containerView.addSubview($0)
        }
        
        [commentHeaderView, commentView].forEach {
            commentBoxView.addSubview($0)
        }
        
        [commentLabel].forEach {
            commentHeaderView.addSubview($0)
        }
        
        [memoHeaderView, memoView].forEach {
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
        
        headerTitle.snp.makeConstraints { make in
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
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(229)
        }
        
        commentHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(36)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        commentView.snp.makeConstraints { make in
            make.top.equalTo(commentHeaderView.snp.bottom).offset(10)
            make.leading.equalTo(commentLabel)
            make.width.equalTo(307)
            make.height.equalTo(169)
        }
        
        commentMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(commentBoxView.snp.bottom).offset(8)
            make.trailing.equalTo(commentBoxView.snp.trailing)
        }
        
        memoBoxView.snp.makeConstraints { make in
            make.top.equalTo(commentMaxLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(101)
        }
        
        memoHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(36)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        memoView.snp.makeConstraints { make in
            make.top.equalTo(memoHeaderView.snp.bottom).offset(10)
            make.leading.equalTo(commentLabel)
            make.width.equalTo(307)
            make.height.equalTo(41)
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
        commentView.delegate = self
        memoView.delegate = self
    }
    
    // 현재는 홈뷰로 가는 상황
    @objc private func backButtonDidTap() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // TODO: - 서버통신 시 구현 (POST)
    @objc private func checkButtonDidTap() {
        // doSomething()
    }
    
    private func config() {
        backButton.setImage(ImageLiterals.Icn.back, for: .normal)
        bookImgView.image = ImageLiterals.Sample.book1
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        }

    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self,
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,
            name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    @objc
    private func keyboardShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary

        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue

        if focus == 1 {
            self.view.transform = CGAffineTransform(translationX: 0,
                                                    y: (containerView.frame.height - keyboardRectangle.height - commentBoxView.frame.maxY - 36))
        } else if focus == 2 {
            self.view.transform = CGAffineTransform(translationX: 0,
                y: (self.view.frame.height - keyboardRectangle.height - memoBoxView.frame.maxY - 36))
        }
    }

    @objc
    private func keyboardHide(notification: NSNotification) {
        self.view.transform = .identity
    }
}

extension EditBookVC: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentComment = commentView.text ?? ""
        guard let commentRange = Range(range, in: currentComment)
        else { return false }
        let changedComment = currentComment.replacingCharacters(in: commentRange, with: text)
        commentMaxLabel.text = "\(changedComment.count)/200"
        
        let currentMemo = memoView.text ?? ""
        guard let memoRange = Range(range, in: currentMemo)
        else { return false }
        let changedMemo = currentMemo.replacingCharacters(in: memoRange, with: text)
        memoMaxLabel.text = "\(changedMemo.count)/50"
        
        return (changedComment.count < 200) && (changedMemo.count < 50)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == I18N.BookDetail.comment {
            textView.text = nil
            textView.textColor = .peekaRed
            focus = 1
        } else if textView.text == I18N.BookDetail.memo {
            textView.text = nil
            textView.textColor = .peekaRed
            focus = 2
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            commentView.text = I18N.BookDetail.comment
            commentView.textColor = .peekaGray1
        } else if memoView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            memoView.text = I18N.BookDetail.memo
            memoView.textColor = .peekaGray1
        }
    }
}

