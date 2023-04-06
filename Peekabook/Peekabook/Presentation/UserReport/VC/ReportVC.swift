//
//  ReportVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/21.
//

import UIKit

import SnapKit
import Then

import Moya

enum ReportMenu {
    case post
    case insults
    case promote
    case nickname
    case etc
    
    var rawValue: String {
        switch self {
        case .post:
            return I18N.Report.post
        case .insults:
            return I18N.Report.insults
        case .promote:
            return I18N.Report.promote
        case .nickname:
            return I18N.Report.nickname
        case .etc:
            return I18N.Report.etc
        }
    }
}

final class ReportVC: UIViewController {

    // MARK: - UI Components
    
    private let reportArray: [ReportMenu] = [.post, .insults, .promote, .nickname, .etc]
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Report.title)
        .addUnderlineView()
    
    private let containerScorllView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let selectLabel = UILabel().then {
        $0.text = I18N.Report.selectTitle
        $0.textColor = .peekaRed
        $0.font = .h3
    }
    
    private lazy var reportTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.allowsSelection = false
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
    }
    
    private let topLineView = UIView()
    
    private let boxView = UIView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    
    private lazy var textView = UITextView().then {
        $0.text = I18N.Report.placeholder
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
        $0.returnKeyType = .done
    }
    
    private let reportInfoLabel = UILabel().then {
        $0.text = I18N.Report.reportInfo
        $0.font = .s2
        $0.textColor = .peekaRed
    }
    
    private lazy var reportButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Report.buttonTitle, for: .normal)
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
        registerCell()
        addTapGesture()
        addKeyboardObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout

extension ReportVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        reportTableView.backgroundColor = .peekaBeige
        topLineView.backgroundColor = .peekaGray1
        boxView.backgroundColor = .peekaWhite_60
        textView.backgroundColor = .clear
        reportButton.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, containerScorllView)

        containerScorllView.addSubviews(selectLabel, reportTableView, topLineView, boxView, reportInfoLabel, reportButton)
        
        boxView.addSubview(textView)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScorllView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        selectLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.leading.equalToSuperview().offset(20)
        }
        
        reportTableView.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(naviBar)
            $0.height.equalTo(260)
        }
        
        topLineView.snp.makeConstraints {
            $0.top.equalTo(reportTableView.snp.top)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(0.5)
        }

        boxView.snp.makeConstraints {
            $0.top.equalTo(reportTableView.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(reportTableView).inset(20)
            $0.height.equalTo(148)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.trailing.bottom.equalToSuperview().inset(14)
            $0.height.equalTo(120)
        }
        
        reportInfoLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(43)
            $0.leading.equalTo(boxView.snp.leading)
        }

        reportButton.snp.makeConstraints {
            $0.top.equalTo(reportInfoLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(boxView)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

// MARK: - Methods

extension ReportVC {
    private func setDelegate() {
        textView.delegate = self
        reportTableView.delegate = self
        reportTableView.dataSource = self
    }
    
    private func registerCell() {
        reportTableView.register(ReportTVC.self, forCellReuseIdentifier: ReportTVC.className)
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
        containerScorllView.contentInset = contentInset
        containerScorllView.scrollIndicatorInsets = contentInset
        containerScorllView.setContentOffset(CGPoint(x: 0, y: 350), animated: true)
        return
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerScorllView.contentInset = contentInset
        containerScorllView.scrollIndicatorInsets = contentInset
    }
}

extension ReportVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTVC.className, for: indexPath) as? ReportTVC
        else {
            return UITableViewCell()
        }
        cell.setLabel(with: reportArray[safe: indexPath.row]!.rawValue)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row+1)
    }
}

extension ReportVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == I18N.Report.placeholder {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = I18N.Report.placeholder
            textView.textColor = .peekaGray1
        }
    }
}
