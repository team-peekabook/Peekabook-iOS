//
//  EditMyPickVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class EditMyPickVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    
    private let naviContainerView = UIView()

    private lazy var backButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.back, for: .normal)
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var completeButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.check, for: .normal)
        $0.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = I18N.BookShelf.editPickDescription
        $0.font = .s1
        $0.textColor = .peekaRed
        $0.textAlignment = .left
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    // MARK: - @objc Function
    
    @objc
    private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func completeButtonDidTap() {
        print("confirmButtonDidTap")
    }
}

// MARK: - UI & Layout
extension EditMyPickVC {
    
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubviews(naviContainerView)
        naviContainerView.addSubviews(backButton, completeButton, descriptionLabel)
        
        naviContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(65)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.leading.equalToSuperview().offset(20)
        }
    }
}

// MARK: - Methods
