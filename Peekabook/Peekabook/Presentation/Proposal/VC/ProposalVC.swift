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

    // MARK: - UI Components
    
    private let headerView = UIView()
    
    private lazy var touchBackButton = UIButton().then {
        $0.addTarget(self, action: #selector(popToSearchView), for: .touchUpInside)
    }
    
    private let headerTitle = UILabel().then {
        $0.text = I18N.BookProposal.title
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private lazy var touchCheckButton = UIButton().then {
        $0.setTitle(I18N.BookEdit.done, for: .normal)
        $0.titleLabel!.font = .h4
        $0.setTitleColor(.peekaRed, for: .normal)
        $0.addTarget(self, action: #selector(presentToPopUpView), for: .touchUpInside)
    }
    
    private let bookImgView = UIImageView()
    
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
    
    private let recommendBoxView = UIView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
        
    private let recommendHeaderView = UIView()
        
    private let recommendLabel = UILabel().then {
        $0.text = "받는사람"
        $0.font = .h1
        $0.textColor = .white
    }
        
    private let lineView = UIView()
        
    private var personNameLabel = UILabel().then {
        $0.text = "고두영"
        $0.font = .h1
        $0.textColor = .white
    }
    
    private let recommendView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.text = I18N.PlaceHolder.recommend
        $0.autocorrectionType = .no
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
        
        touchBackButton.setImage(ImageLiterals.Icn.back, for: .normal)
        
        bookImgView.image = ImageLiterals.Sample.book1
    }
    
    private func setLayout() {
        view.addSubview(headerView)
        
        [touchBackButton, headerTitle, touchCheckButton].forEach {
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
        
        touchBackButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        headerTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        touchCheckButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(11)
            make.width.height.equalTo(48)
        }
        
        bookImgView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
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
    
    @objc private func popToSearchView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func presentToPopUpView() {
        let popupViewController = ConfirmPopUpViewController()
        popupViewController.modalPresentationStyle = .overFullScreen
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
    
    // MARK: - @objc Function
    
    @objc
    private func keyBoardShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        self.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - keyboardRectangle.height - recommendBoxView.frame.maxY - 36))
    }

    @objc
    private func keyboardHide(notification: NSNotification) {
        self.view.transform = .identity
    }
}

extension ProposalVC: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentComment = recommendView.text ?? ""
        guard let commentRange = Range(range, in: currentComment)
        else { return false }
        let changedComment = currentComment.replacingCharacters(in: commentRange, with: text)
        recommendMaxLabel.text = "\(changedComment.count)/200"
        
        return (changedComment.count < 200)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == I18N.PlaceHolder.recommend) {
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
