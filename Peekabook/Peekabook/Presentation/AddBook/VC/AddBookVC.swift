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
        
        [bookImgView, nameLabel, authorLabel].forEach {
            containerView.addSubview($0)
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
