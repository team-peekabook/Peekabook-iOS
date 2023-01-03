//
//  AddBookVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class AddBookVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    
    private let headerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let touchBackButton = UIButton().then {
        $0.addTarget(AddBookVC.self, action: #selector(popToSearchView), for: .touchUpInside)
    }
    
    private let headerTitle = UILabel().then {
        $0.text = "책 등록하기"
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private let touchCheckButton = UIButton().then {
        $0.addTarget(AddBookVC.self, action: #selector(pushToDetailView), for: .touchUpInside)
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
        $0.layer.borderColor = UIColor(red: 0.565, green: 0.169, blue: 0.129, alpha: 1).cgColor
    }
    
    private let commentHeader = UIView().then {
        $0.backgroundColor = .peekaRed
    }
    
    private let commentLabel = UILabel().then {
        $0.text = "한 마디"
        $0.font = .h1
        $0.textColor = .white
    }
    
    private let commentViewPlaceholder = "한 마디를 남겨주세요."
    private lazy var commentView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.text = commentViewPlaceholder
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
        $0.layer.borderColor = UIColor(red: 0.565, green: 0.169, blue: 0.129, alpha: 1).cgColor
    }
    
    private let memoHeader = UIView().then {
        $0.backgroundColor = .peekaRed
    }
    
    private let memoLabel = UILabel().then {
        $0.text = "메모"
        $0.font = .h1
        $0.textColor = .white
    }
    
    private let memoViewPlaceholder = "메모를 남겨주세요."
    private lazy var memoView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.text = commentViewPlaceholder
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
        configButton()
        configImageView()
    }
}

// MARK: - UI & Layout

extension AddBookVC {
    
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
            make.trailing.equalToSuperview()
        }
        
        bookImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(bookImgView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        commentBox.snp.makeConstraints {
            $0.top.equalTo(authorLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(229)
        }
        
        commentHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        commentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
        }
        
        commentView.snp.makeConstraints {
            $0.top.equalTo(commentHeader.snp.bottom).offset(10)
            $0.leading.equalTo(commentLabel)
            $0.width.equalTo(307)
            $0.height.equalTo(169)
        }
        
        commentMaxLabel.snp.makeConstraints {
            $0.top.equalTo(commentBox.snp.bottom).offset(8)
            $0.trailing.equalTo(commentBox.snp.trailing)
        }
        
        memoBox.snp.makeConstraints {
            $0.top.equalTo(commentMaxLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(335)
            $0.height.equalTo(101)
        }
        
        memoHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        memoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
        }
        
        memoView.snp.makeConstraints {
            $0.top.equalTo(memoHeader.snp.bottom).offset(10)
            $0.leading.equalTo(commentLabel)
            $0.width.equalTo(307)
            $0.height.equalTo(41)
        }
        
        memoMaxLabel.snp.makeConstraints {
            $0.top.equalTo(memoBox.snp.bottom).offset(8)
            $0.trailing.equalTo(memoBox.snp.trailing)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    @objc private func popToSearchView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // TODO: - push 함수 작성
    @objc private func pushToDetailView() {
        
    }
    
    private func configButton() {
        touchBackButton.setImage(ImageLiterals.Icn.back, for: .normal)
        touchCheckButton.setImage(ImageLiterals.Icn.check, for: .normal)
    }
    
    private func configImageView(){
        bookImgView.image = ImageLiterals.Sample.book1
    }
}

// MARK: - Methods
