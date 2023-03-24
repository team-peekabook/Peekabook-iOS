//
//  DeclareVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/21.
//

import UIKit

import SnapKit
import Then

import Moya

final class DeclareVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Declare.title)
        .addUnderlineView()
    
    private let containerView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let selectLabel = UILabel().then {
        $0.text = I18N.Declare.selectTitle
        $0.textColor = .peekaRed
        $0.font = .h3
    }
    
    private lazy var declareTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.allowsSelection = false
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let topLineView = UIView()
    
    private let declareArray: [String] = [
        I18N.Declare.reason1,
        I18N.Declare.reason2,
        I18N.Declare.reason3,
        I18N.Declare.reason4,
        I18N.Declare.reason5
    ]
    
    private let boxView = UIView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    
    private lazy var textView = UITextView().then {
        $0.text = I18N.Declare.placeholder
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
        $0.returnKeyType = .done
    }
    
    private let declareInfoLabel = UILabel().then {
        $0.text = I18N.Declare.declareInfo
        $0.font = .s2
        $0.textColor = .peekaRed
    }
    
    private lazy var declareButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Declare.buttonTitle, for: .normal)
        $0.titleLabel!.font = .h3
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(declareButtonDidTap), for: .touchUpInside)
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setBackgroundColor()
        setLayout()
        register()
        addTapGesture()
        addKeyboardObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout

extension DeclareVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        declareTableView.backgroundColor = .peekaBeige
        topLineView.backgroundColor = .peekaGray1
        boxView.backgroundColor = .peekaWhite_60
        textView.backgroundColor = .clear
        declareButton.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, containerView)

        containerView.addSubviews(selectLabel, declareTableView, topLineView, boxView, declareInfoLabel, declareButton)
        
        boxView.addSubview(textView)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        selectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.leading.equalToSuperview().offset(20)
        }
        
        declareTableView.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(naviBar)
            $0.height.equalTo(260)
        }
        
        topLineView.snp.makeConstraints {
            $0.top.equalTo(declareTableView.snp.top)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }

        boxView.snp.makeConstraints {
            $0.top.equalTo(declareTableView.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(declareTableView).inset(20)
            $0.height.equalTo(148)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.trailing.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(120)
        }
        
        declareInfoLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(43)
            $0.leading.equalTo(boxView.snp.leading)
        }

        declareButton.snp.makeConstraints {
            $0.top.equalTo(declareInfoLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(boxView)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

// MARK: - Methods

extension DeclareVC {
    private func register() {
        declareTableView.register(DeclareTableViewCell.self, forCellReuseIdentifier: DeclareTableViewCell.className)
    }
    
    @objc private func declareButtonDidTap() {
        print("신고완료")
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
        containerView.setContentOffset(CGPoint(x: 0, y: 350), animated: true)
        return
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerView.contentInset = contentInset
        containerView.scrollIndicatorInsets = contentInset
    }
}

extension DeclareVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return declareArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeclareTableViewCell.className, for: indexPath) as? DeclareTableViewCell
        else {
            return UITableViewCell()
        }
        cell.label.text = declareArray[safe: indexPath.row]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row+1)
    }
}

extension DeclareVC: UITextViewDelegate {
    
    private func setDelegate() {
        textView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == I18N.Declare.placeholder {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = I18N.Declare.placeholder
            textView.textColor = .peekaGray1
        }
    }
}
