//
//  MyNotificationVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class MyNotificationVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    
    private let headerContainerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.close, for: .normal)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private let notificationLabel = UILabel().then {
        $0.text = "알림"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private lazy var notificationTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = true
        $0.isScrollEnabled = true
        $0.allowsSelection = false
        $0.allowsMultipleSelection = false
        $0.backgroundColor = UIColor.peekaBeige
//        $0.delegate = self
//        $0.dataSource = self
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - UI & Layout

extension MyNotificationVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerContainerView.backgroundColor = UIColor.peekaBeige
        notificationTableView.backgroundColor = UIColor.peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(headerContainerView, notificationTableView)
        headerContainerView.addSubviews(backButton, notificationLabel)
        
        headerContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        
        notificationLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        notificationTableView.snp.makeConstraints { make in
            make.top.equalTo(headerContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods
