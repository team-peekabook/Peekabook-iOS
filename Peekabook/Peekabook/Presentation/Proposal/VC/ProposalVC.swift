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
    var publisher: String = ""

    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton)
        .addMiddleLabel(title: I18N.BookProposal.title)
        .addRightButton(with: I18N.BookProposal.done)
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
    
    private lazy var peekaProposalView = CustomTextView()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addTapGesture()
        addKeyboardObserver()
        updateProposalView()
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
    }
    
    private func setLayout() {
        [containerView, naviBar].forEach {
            view.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, peekaProposalView].forEach {
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
        
        peekaProposalView.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.height.equalTo(229)
        }
    }
}

// MARK: - Methods

extension ProposalVC {
    
    private func updateProposalView() {
        peekaProposalView.personNameLabel.text = personName
        peekaProposalView.updateTextView(type: .bookProposal)
    }
    
    @objc private func backButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    @objc private func checkButtonDidTap() {
        let popupViewController = ProposalConfirmPopUpVC()
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.recommendDesc = peekaProposalView.text == I18N.PlaceHolder.recommend ?  "" : peekaProposalView.text
        popupViewController.bookTitle = nameLabel.text!
        popupViewController.bookImage = imageUrl
        popupViewController.author = authorLabel.text!
        popupViewController.personId = personId
        popupViewController.personName = personName
        popupViewController.bookImage = imageUrl
        popupViewController.publisher = publisher
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
        self.publisher = model.publisher
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
        
        let position = peekaProposalView.getPositionForKeyboard(keyboardFrame: keyboardFrame)
        containerView.setContentOffset(position, animated: true)
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerView.contentInset = contentInset
        containerView.scrollIndicatorInsets = contentInset
    }
}
