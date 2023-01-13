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
    
    private let bookImgView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.contentMode = .scaleAspectFit
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 0, y: 4, blur: 4, spread: 0)
    }
    
    private var nameLabel = UILabel().then {
        $0.font = .h3
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = .peekaRed
    }
    
    private var authorLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed
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
        
    private var personNameLabel = UILabel().then {
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    private let recommendView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.text = I18N.PlaceHolder.recommend
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.registerForKeyboardNotification()
        }
    
    deinit {
        self.removeRegisterForKeyboardNotification()
    }
}

// MARK: - UI & Layout

extension ProposalVC {
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        recommendBoxView.backgroundColor = .white
        recommendHeaderView.backgroundColor = .peekaRed
        lineView.backgroundColor = .white
        recommendView.backgroundColor = .clear
        
        backButton.setImage(ImageLiterals.Icn.back, for: .normal)
    }
    
    private func setLayout() {
        view.addSubview(headerView)
        
        [backButton, headerTitle, checkButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, recommendBoxView, recommendMaxLabel].forEach {
            view.addSubview($0)
        }
        
        [recommendHeaderView, recommendView].forEach {
            recommendBoxView.addSubview($0)
        }
        
        [recommendLabel, lineView, personNameLabel].forEach {
            recommendHeaderView.addSubview($0)
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
            make.top.equalTo(headerView.snp.bottom).offset(24)
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
                
        recommendView.snp.makeConstraints { make in
            make.top.equalTo(recommendHeaderView.snp.bottom).offset(10)
            make.leading.equalTo(recommendLabel)
            make.width.equalTo(307)
            make.height.equalTo(169)
        }
                
        recommendMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(recommendBoxView.snp.bottom).offset(8)
            make.trailing.equalTo(recommendBoxView.snp.trailing)
        }
    }
}

// MARK: - Methods

extension ProposalVC {
    private func setDelegate() {
        recommendView.delegate = self
    }
    
    @objc private func backButtonDidTap() {
        self.dismiss(animated: true)
    }
    
    @objc private func checkButtonDidTap() {
        let popupViewController = ConfirmPopUpViewController()
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.recommendDesc = recommendView.text
        popupViewController.bookImage = imageUrl
        popupViewController.author = authorLabel.text!
        popupViewController.personId = personId
        popupViewController.personNameLabel.text = personName
        print(personName)
        print(personId)
        self.present(popupViewController, animated: false)
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyBoardShow),
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
    
    func dataBind(model: BookInfoModel) {
        nameLabel.text = model.title
        authorLabel.text = model.author
        imageUrl = model.image
        bookImgView.kf.indicatorType = .activity
        bookImgView.kf.setImage(with: URL(string: imageUrl)!)
    }
    
    // MARK: - @objc Function
    
    @objc
    private func keyBoardShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.view.transform = CGAffineTransform(translationX: 0,
            y: (self.view.frame.height - keyboardRectangle.height - recommendBoxView.frame.maxY - 36))
    }

    @objc
    private func keyboardHide(notification: NSNotification) {
        self.view.transform = .identity
    }
}

extension ProposalVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentComment = recommendView.text ?? ""
        guard let commentRange = Range(range, in: currentComment)
        else { return false }
        let changedComment = currentComment.replacingCharacters(in: commentRange, with: text)
        recommendMaxLabel.text = "\(changedComment.count)/200"
        
        return (changedComment.count < 200)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == I18N.PlaceHolder.recommend {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if recommendView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            recommendView.text = I18N.PlaceHolder.recommend
            recommendView.textColor = .peekaGray1
        }
    }
}
