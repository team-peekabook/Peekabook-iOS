//
//  NetworkAlertPopUpVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/06/10.
//

import UIKit

import SnapKit
import Then

import Moya

final class NetworkAlertPopUpVC: UIViewController {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let popUpView = UIView()
    
    private let alertLabel: UILabel = {
        let label = UILabel()
        label.text = I18N.Alert.networkError
        label.font = .h4
        label.textColor = .peekaRed
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle(I18N.Alert.retry, for: .normal)
        button.titleLabel!.font = .h1
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .peekaRed
        button.addTarget(self, action: #selector(retryButtonDidTap), for: .touchUpInside)
        return button
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension NetworkAlertPopUpVC {
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
        containerView.backgroundColor = .black.withAlphaComponent(0.7)
        popUpView.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubview(containerView)
        containerView.addSubview(popUpView)
        popUpView.addSubviews(alertLabel, retryButton)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
        
        alertLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
        }
        
        retryButton.snp.makeConstraints {
            $0.top.equalTo(alertLabel.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(263)
            $0.height.equalTo(40)
        }
    }
}

// MARK: - Methods

extension NetworkAlertPopUpVC {
    
    @objc
    private func retryButtonDidTap() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }) { _ in
            self.dismiss(animated: false)
        }
    }
}
