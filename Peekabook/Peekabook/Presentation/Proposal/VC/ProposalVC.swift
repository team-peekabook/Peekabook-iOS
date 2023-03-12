//
//  ProposalVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/05.
//

import UIKit

import SnapKit
import Then

import Moya

final class ProposalVC: UIViewController {

    // MARK: - Properties
    
    var imageUrl: String = ""
    var personName: String = ""
    var personId: Int = 0
    var bookTitle: String = ""
    var author: String = ""

    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton)
        .addMiddleLabel(title: I18N.BookProposal.title)
        .addRightButton(with: I18N.BookProposal.done)
        .addRightButtonAction {
            self.checkButtonDidTap()
        }
        .addLefttButtonAction {
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
        $0.font = .h3
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .peekaRed
    }
    
    private let authorLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.textAlignment = .center
    }
    
    private let recommendBoxView = UIView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
        
    private let recommendHeaderView = UIView()
        
    private let recommendLabel = UILabel().then {
        $0.text = I18N.BookProposal.personName
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
        
    private let lineView = UIView()
        
    private let personNameLabel = UILabel().then {
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    private let recommendTextView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.text = I18N.PlaceHolder.recommend
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
        $0.returnKeyType = .done
    }
        
    private let recommendMaxLabel = UILabel().then {
        $0.text = I18N.BookAdd.commentLength
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout

extension ProposalVC {
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        
        containerView.backgroundColor = .clear
        recommendBoxView.backgroundColor = .white
        recommendHeaderView.backgroundColor = .peekaRed
        lineView.backgroundColor = .white
        recommendTextView.backgroundColor = .clear
        personNameLabel.text = personName
    }
    
    private func setLayout() {
        [containerView, naviBar].forEach {
            view.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, recommendBoxView, recommendMaxLabel].forEach {
            containerView.addSubview($0)
        }
        
        [recommendHeaderView, recommendTextView].forEach {
            recommendBoxView.addSubview($0)
        }
        
        [recommendLabel, lineView, personNameLabel].forEach {
            recommendHeaderView.addSubview($0)
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
            $0.width.equalTo(100)
            $0.height.equalTo(160)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(bookImgView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(310)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(310)
        }
        
        recommendBoxView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(229)
        }
        
        recommendHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(36)
        }
                
        recommendLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
        }
                
        lineView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(recommendLabel.snp.trailing).offset(8)
            $0.width.equalTo(1)
            $0.height.equalTo(12)
        }
                
        personNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(lineView.snp.trailing).offset(8)
        }
                
        recommendTextView.snp.makeConstraints {
            $0.top.equalTo(recommendHeaderView.snp.bottom).offset(10)
            $0.leading.equalTo(recommendLabel)
            $0.width.equalTo(307)
            $0.height.equalTo(169)
        }
                
        recommendMaxLabel.snp.makeConstraints {
            $0.top.equalTo(recommendBoxView.snp.bottom).offset(8)
            $0.trailing.equalTo(recommendBoxView.snp.trailing)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension ProposalVC {
    private func setDelegate() {
        recommendTextView.delegate = self
    }
    
    @objc private func backButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    @objc private func checkButtonDidTap() {
        let popupViewController = ConfirmPopUpVC()
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.recommendDesc = recommendTextView.text
        popupViewController.bookTitle = nameLabel.text!
        popupViewController.bookImage = imageUrl
        popupViewController.author = authorLabel.text!
        popupViewController.personId = personId
        popupViewController.personName = personName
        popupViewController.bookImage = imageUrl
        self.present(popupViewController, animated: false)
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
    
    func dataBind(model: BookInfoModel) {
        nameLabel.text = model.title
        authorLabel.text = model.author.replacingOccurrences(of: "^", with: ", ")
        imageUrl = model.image
        bookImgView.kf.indicatorType = .activity
        bookImgView.kf.setImage(with: URL(string: imageUrl)!)
    }
    
    // MARK: - @objc Function
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
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
        
        let textViewHeight = recommendBoxView.frame.height
        let position = CGPoint(x: 0, y: recommendBoxView.frame.origin.y - keyboardFrame.size.height + textViewHeight - 40)
        containerView.setContentOffset(position, animated: true)
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerView.contentInset = contentInset
        containerView.scrollIndicatorInsets = contentInset
    }
}

extension ProposalVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        recommendMaxLabel.text = "\(recommendTextView.text.count)/200"
        if recommendTextView.text.count > 200 {
            recommendTextView.deleteBackward()
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == I18N.PlaceHolder.recommend {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if recommendTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            recommendTextView.text = I18N.PlaceHolder.recommend
            recommendTextView.textColor = .peekaGray1
        }
    }
}
