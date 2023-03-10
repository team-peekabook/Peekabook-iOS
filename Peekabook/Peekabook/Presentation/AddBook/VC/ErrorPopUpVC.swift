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

final class ErrorPopUpVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    private let popUpView = UIView()
    
    private let emptyLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = I18N.ErrorPopUp.empty
        $0.font = .h4
        $0.textColor = .peekaRed
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.close, for: .normal)
        $0.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var textSearchButton = UIButton().then {
        $0.setTitle(I18N.ErrorPopUp.forText, for: .normal)
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .peekaRed
        $0.addTarget(self, action: #selector(textSearchButtonDidTap), for: .touchUpInside)
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension ErrorPopUpVC {
    
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        popUpView.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        [emptyLabel, textSearchButton, cancelButton].forEach {
            popUpView.addSubview($0)
        }
        
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(134)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(33)
            $0.centerX.equalToSuperview()
        }
        
        textSearchButton.snp.makeConstraints {
            $0.top.equalTo(emptyLabel.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(263)
            $0.height.equalTo(40)
        }
    }
}

// MARK: - Methods

extension ErrorPopUpVC {
    
    @objc private func textSearchButtonDidTap() {
        let bookSearchVC = BookSearchVC()
        bookSearchVC.modalPresentationStyle = .fullScreen
        self.present(bookSearchVC, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
}
