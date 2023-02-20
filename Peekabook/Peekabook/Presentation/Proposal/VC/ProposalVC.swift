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
    
    private let headerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    private let headerTitle = UILabel().then {
        $0.text = I18N.BookProposal.title
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
        $0.becomeFirstResponder()
    }
        
    private let recommendMaxLabel = UILabel().then {
        $0.text = "0/200"
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
        headerView.backgroundColor = .clear
        containerView.backgroundColor = .clear
        recommendBoxView.backgroundColor = .white
        recommendHeaderView.backgroundColor = .peekaRed
        lineView.backgroundColor = .white
        recommendTextView.backgroundColor = .clear
        personNameLabel.text = personName
        backButton.setImage(ImageLiterals.Icn.back, for: .normal)
    }
    
    private func setLayout() {
        [containerView, headerView].forEach {
            view.addSubview($0)
        }
        
        [backButton, headerTitle, checkButton].forEach {
            headerView.addSubview($0)
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
            make.width.equalTo(100)
            make.height.equalTo(160)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImgView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(310)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(310)
        }
        
        recommendBoxView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(229)
        }
        
        recommendHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(36)
        }
                
        recommendLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
                
        lineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(recommendLabel.snp.trailing).offset(8)
            make.width.equalTo(1)
            make.height.equalTo(12)
        }
                
        personNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(lineView.snp.trailing).offset(8)
        }
                
        recommendTextView.snp.makeConstraints { make in
            make.top.equalTo(recommendHeaderView.snp.bottom).offset(10)
            make.leading.equalTo(recommendLabel)
            make.width.equalTo(307)
            make.height.equalTo(169)
        }
                
        recommendMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(recommendBoxView.snp.bottom).offset(8)
            make.trailing.equalTo(recommendBoxView.snp.trailing)
            make.bottom.equalToSuperview()
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
