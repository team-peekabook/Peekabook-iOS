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
        $0.setImage(ImageLiterals.Icn.back, for: .normal)
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
    
    private lazy var peekaProposalView = CustomTextView()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addTapGesture()
        addKeyboardObserver()
        peekaProposalView.personNameLabel.text = personName
        peekaProposalView.updateTextView(type: .bookProposal)
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
    }
    
    private func setLayout() {
        [containerView, headerView].forEach {
            view.addSubview($0)
        }
        
        [backButton, headerTitle, checkButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, peekaProposalView].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        headerTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(11)
            $0.width.height.equalTo(48)
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
    
    @objc private func backButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    @objc private func checkButtonDidTap() {
        let popupViewController = ConfirmPopUpVC()
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.recommendDesc = peekaProposalView.text
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
        
        let position = peekaProposalView.getPositionForKeyboard(keyboardFrame: keyboardFrame)
        containerView.setContentOffset(position, animated: true)
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerView.contentInset = contentInset
        containerView.scrollIndicatorInsets = contentInset
    }
}
