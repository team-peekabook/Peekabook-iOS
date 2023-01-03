//
//  RecommendVC.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import SnapKit
import Then

import Moya

final class RecommendVC: UIViewController {

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
    
    private let recommendBox = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
        
    private let recommendHeader = UIView().then {
        $0.backgroundColor = .peekaRed
    }
        
    private let recommendLabel = UILabel().then {
        $0.text = "받는사람"
        $0.font = .h1
        $0.textColor = .white
    }
        
    private let lineView = UIView().then {
        $0.backgroundColor = .white
    }
        
    private var personName = UILabel().then {
        $0.text = "고두영"
        $0.font = .h1
        $0.textColor = .white
    }
        
    private let recommendViewPlaceholder = "추천사를 적어주세요."
    private lazy var recommendView = UITextView().then {
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.text = recommendViewPlaceholder
        $0.backgroundColor = .clear
    }
        
    lazy var recommendMaxLabel = UILabel().then {
        $0.text = "0/200"
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

extension RecommendVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubview(headerView)
        
        [touchBackButton, headerTitle, touchCheckButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel, recommendBox, recommendMaxLabel].forEach {
            view.addSubview($0)
        }
        
        [recommendHeader, recommendView].forEach {
            recommendBox.addSubview($0)
        }
        
        [recommendLabel, lineView, personName].forEach {
            recommendHeader.addSubview($0)
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
        
        recommendBox.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(229)
        }
        
        recommendHeader.snp.makeConstraints { make in
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
                
        personName.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(lineView.snp.trailing).offset(8)
        }
                
        recommendView.snp.makeConstraints { make in
            make.top.equalTo(recommendHeader.snp.bottom).offset(10)
            make.leading.equalTo(recommendLabel)
            make.width.equalTo(307)
            make.height.equalTo(169)
        }
                
        recommendMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(recommendBox.snp.bottom).offset(8)
            make.trailing.equalTo(recommendBox.snp.trailing)
        }
    }
}

// MARK: - Methods

extension RecommendVC {
    private func setDelegate() {
    }
    
    @objc private func popToSearchView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // TODO: - push 함수 작성 필요
    @objc private func pushToDetailView() {
        // doSomething()
    }
    
    private func configButton() {
        touchBackButton.setImage(ImageLiterals.Icn.back, for: .normal)
        touchCheckButton.setImage(ImageLiterals.Icn.check, for: .normal)
    }
    
    private func configImageView() {
        bookImgView.image = ImageLiterals.Sample.book1
    }
}
