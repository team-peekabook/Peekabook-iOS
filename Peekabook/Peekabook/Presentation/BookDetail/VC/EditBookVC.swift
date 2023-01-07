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

    // MARK: - UI Components
    
    private let headerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var touchBackButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchBackButtonDidTap), for: .touchUpInside)
    }
    
    private let headerTitle = UILabel().then {
        $0.text = "책 수정하기"
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private let touchCheckButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel!.font = .h4
        $0.setTitleColor(.peekaRed, for: .normal)
        $0.addTarget(AddBookVC.self, action: #selector(touchCheckButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var containerView = UIScrollView().then {
        $0.backgroundColor = .clear
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
    
    private let commentBox = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    
    private let commentHeader = UIView().then {
        $0.backgroundColor = .peekaRed
    }
    
    private let commentLabel = UILabel().then {
        $0.text = "한 마디"
        $0.font = .h1
        $0.textColor = .white
    }
    
    private lazy var commentView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.text = I18N.BookDetail.comment
        $0.backgroundColor = .clear
    }
    
    lazy var commentMaxLabel = UILabel().then {
        $0.text = "0/200"
        $0.font = .h2
        $0.textColor = .peekaGray2
    }
    
    private let memoBox = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    
    private let memoHeader = UIView().then {
        $0.backgroundColor = .peekaRed
    }
    
    private let memoLabel = UILabel().then {
        $0.text = "메모"
        $0.font = .h1
        $0.textColor = .white
    }
    
    private lazy var memoView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.text = I18N.BookDetail.memo
        $0.backgroundColor = .clear
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
        config()
    }
}

// MARK: - UI & Layout
extension EditBookVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        [containerView, headerView].forEach {
            view.addSubview($0)
        }
        
        [touchBackButton, headerTitle, touchCheckButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, commentBox, commentMaxLabel, memoBox, memoMaxLabel].forEach {
            containerView.addSubview($0)
        }
        
        [commentHeader, commentView].forEach {
            commentBox.addSubview($0)
        }
        
        [commentLabel].forEach {
            commentHeader.addSubview($0)
        }
        
        [memoHeader, memoView].forEach {
            memoBox.addSubview($0)
        }
        
        [memoLabel].forEach {
            memoHeader.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
        
        commentBox.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(229)
        }
        
        commentHeader.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(36)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        commentView.snp.makeConstraints { make in
            make.top.equalTo(commentHeader.snp.bottom).offset(10)
            make.leading.equalTo(commentLabel)
            make.width.equalTo(307)
            make.height.equalTo(169)
        }
        
        commentMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(commentBox.snp.bottom).offset(8)
            make.trailing.equalTo(commentBox.snp.trailing)
        }
        
        memoBox.snp.makeConstraints { make in
            make.top.equalTo(commentMaxLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(101)
        }
        
        memoHeader.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(36)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        memoView.snp.makeConstraints { make in
            make.top.equalTo(memoHeader.snp.bottom).offset(10)
            make.leading.equalTo(commentLabel)
            make.width.equalTo(307)
            make.height.equalTo(41)
        }
        
        memoMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(memoBox.snp.bottom).offset(8)
            make.trailing.equalTo(memoBox.snp.trailing)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
}

// MARK: - Methods

extension EditBookVC {
    // TODO: - 바코드 스캔뷰로 다시 가게 해야함
    // 현재는 홈뷰로 가는 상황
    @objc private func touchBackButtonDidTap() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // TODO: - push 함수 작성 필요
    @objc private func touchCheckButtonDidTap() {
        // doSomething()
    }
    
    private func config() {
        touchBackButton.setImage(ImageLiterals.Icn.back, for: .normal)
        
        bookImgView.image = ImageLiterals.Sample.book1
    }
}
