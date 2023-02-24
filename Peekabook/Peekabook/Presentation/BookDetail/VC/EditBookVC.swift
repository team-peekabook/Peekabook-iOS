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
    
    private let peekaCommentView = CommentView()
    private let peekaMemoView = CommentView()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setReusableView()
        setUI()
        setLayout()
        addTapGesture()
        addKeyboardObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        peekaCommentView.commentTextView.text = descriptions
        peekaMemoView.commentTextView.text = memo
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout
extension EditBookVC {
    
    private func setReusableView() {
        peekaCommentView.commentBoxView.backgroundColor = .clear
        
        peekaMemoView.commentBoxView.backgroundColor = .clear
        peekaMemoView.commentBoxView.frame.size.height = 101
        peekaMemoView.commentLabel.text = I18N.BookDetail.memo
        peekaMemoView.commentTextView.text = I18N.BookDetail.memoHint
        
        if descriptions != I18N.BookDetail.emptyComment {
            peekaCommentView.commentTextView.textColor = .peekaRed
            peekaCommentView.commentMaxLabel.text = "\(descriptions.count)/200"
        } else {
            peekaCommentView.commentMaxLabel.text = I18N.BookAdd.commentLength
        }
        
        if memo != I18N.BookDetail.emptyMemo {
            peekaMemoView.commentTextView.textColor = .peekaRed
            peekaMemoView.commentMaxLabel.text = "\(memo.count)/50"
        } else {
            peekaMemoView.commentMaxLabel.text = I18N.BookAdd.memoLength
        }
    }
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        backButton.setImage(ImageLiterals.Icn.back, for: .normal)
    }
    
    private func setLayout() {
        [containerView, headerView].forEach {
            view.addSubview($0)
        }
        
        [backButton, headerTitleLabel, checkButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, peekaCommentView, peekaMemoView].forEach {
            containerView.addSubview($0)
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
        
        peekaCommentView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(229)
        }
        
        peekaMemoView.snp.makeConstraints { make in
            make.top.equalTo(peekaCommentView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(101)
            make.bottom.equalToSuperview().inset(36)
        }
    }
}

// MARK: - Methods

extension EditBookVC {
    
    @objc private func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func checkButtonDidTap() {
        print("checkButtonDidTap")
        editMyBookInfo(id: bookIndex, param: EditBookRequest(description: peekaCommentView.commentTextView.text, memo: peekaMemoView.commentTextView.text))
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
        
        if peekaCommentView.commentTextView.isFirstResponder {
            let textViewHeight = peekaCommentView.commentBoxView.frame.height
            let position = CGPoint(x: 0, y: peekaCommentView.commentBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight + 250)
            containerView.setContentOffset(position, animated: true)
            return
        }
        
        if peekaMemoView.commentTextView.isFirstResponder {
            let textViewHeight = peekaMemoView.commentBoxView.frame.height
            let position = CGPoint(x: 0, y: peekaMemoView.commentBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight + 500)
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
