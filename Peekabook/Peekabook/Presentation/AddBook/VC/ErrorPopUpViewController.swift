//
//  ErrorPopUpViewController.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

import Moya

final class ErrorPopUpViewController: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    private let popUpView = UIView().then {
        $0.backgroundColor = .peekaBeige
    }
    
    private var confirmLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "존재하지 않는 책입니다"
        $0.font = .h4
        $0.textColor = .peekaRed
    }
    
    private lazy var textSearchButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchtextSearchButtonDidTap), for: .touchUpInside)
        $0.setTitle("텍스트로 검색하기", for: .normal)
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .peekaRed
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension ErrorPopUpViewController {
    
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        [confirmLabel, textSearchButton].forEach {
            popUpView.addSubview($0)
        }
        
        popUpView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(295)
            make.height.equalTo(134)
        }
        
        confirmLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33)
            make.centerX.equalToSuperview()
        }
        
        textSearchButton.snp.makeConstraints { make in
            make.top.equalTo(confirmLabel.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.width.equalTo(263)
            make.height.equalTo(40)
        }
    }
}

// MARK: - Methods

extension ErrorPopUpViewController {
    @objc private func touchtextSearchButtonDidTap() {
//        self.dismiss(animated: false, completion: nil)
        let nextVC = BookSearchVC()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}
