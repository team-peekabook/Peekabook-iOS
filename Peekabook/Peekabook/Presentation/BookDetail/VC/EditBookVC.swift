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
    
//    var bookImage: String = ""
//    var titleName: String = ""
//    var authorName: String = ""

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
    
    private var commentView = UITextView().then {
        $0.text = I18N.BookDetail.commentHint
        $0.font = .h2
        $0.textColor = .peekaRed
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
        $0.text = I18N.BookDetail.memoHint
        $0.font = .h2
        $0.textColor = .peekaRed
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
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.registerForKeyboardNotification()
        commentView.text = descriptions
        memoView.text = memo
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
        
        commentView.snp.makeConstraints { make in
            make.top.equalTo(commentHeaderView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(300)
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
        
        memoView.snp.makeConstraints { make in
            make.top.equalTo(memoHeaderView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(70)
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
    
    @objc private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func checkButtonDidTap() {
        print("checkButtonDidTap")
        editMyBookInfo(id: bookIndex, param: EditBookRequest(description: commentView.text, memo: memoView.text))
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
        
        if commentView.isFirstResponder {
            let contentViewHeight = containerView.contentSize.height
            let textViewHeight = commentBoxView.frame.height
            let textViewOffsetY = UIScreen.main.bounds.height - (contentInset.bottom + textViewHeight)
            let position = CGPoint(x: 0, y: commentBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight - 5)
            containerView.setContentOffset(position, animated: true)
            return
        }
        
        if memoView.isFirstResponder {
            let contentViewHeight = containerView.contentSize.height
            let textViewHeight = memoBoxView.frame.height
            let textViewOffsetY = UIScreen.main.bounds.height - (contentInset.bottom + textViewHeight)
            let position = CGPoint(x: 0, y: memoBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight)
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == commentView {
            let currentComment = commentView.text ?? ""
            guard let commentRange = Range(range, in: currentComment)
            else { return false }
            let changedComment = currentComment.replacingCharacters(in: commentRange, with: text)
            commentMaxLabel.text = "\(changedComment.count)/200"
            return (changedComment.count < 200)
        }
        if textView == memoView {
            let currentMemo = memoView.text ?? ""
            guard let memoRange = Range(range, in: currentMemo)
            else { return false }
            let changedMemo = currentMemo.replacingCharacters(in: memoRange, with: text)
            memoMaxLabel.text = "\(changedMemo.count)/50"
            return (changedMemo.count < 50)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == I18N.BookDetail.commentHint {
            textView.text = nil
            textView.textColor = .peekaRed
        } else if textView.text == I18N.BookDetail.memoHint {
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
        if commentView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            commentView.text = I18N.BookDetail.commentHint
            commentView.textColor = .peekaGray1
        } else if memoView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            memoView.text = I18N.BookDetail.memoHint
            memoView.textColor = .peekaGray1
        }
    }
}

extension EditBookVC {
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> Void in
                if completion != nil {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
}
