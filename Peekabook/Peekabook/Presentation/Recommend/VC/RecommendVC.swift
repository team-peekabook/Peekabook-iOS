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
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        configButton()
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
}
