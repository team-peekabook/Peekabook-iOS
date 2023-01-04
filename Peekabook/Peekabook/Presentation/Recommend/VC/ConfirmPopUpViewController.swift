//
//  ConfirmPopUpViewController.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/04.
//

import UIKit

import SnapKit
import Then

import Moya

final class ConfirmPopUpViewController: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    private let popUpView = UIView().then {
        $0.backgroundColor = .peekaBeige
    }
    
    private var confirmLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "고두영님에게\n책을 추천하시겠어요?"
        $0.font = .h4
        $0.textColor = .peekaRed
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchCancelButton), for: .touchUpInside)
        $0.setTitle("취소하기", for: .normal)
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .peekaRed
    }
    
    private lazy var okButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchOkButton), for: .touchUpInside)
        $0.setTitle("추천하기", for: .normal)
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .peekaGray2
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension ConfirmPopUpViewController {
    
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        [confirmLabel, cancelButton, okButton].forEach {
            popUpView.addSubview($0)
        }
        
        popUpView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(295)
            make.height.equalTo(136)
        }
        
        confirmLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(confirmLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(124)
            make.height.equalTo(40)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(confirmLabel.snp.bottom).offset(14)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(cancelButton)
        }
    }
}

// MARK: - Methods

extension ConfirmPopUpViewController {
    @objc private func touchCancelButton() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // TODO: - 현재는 그냥 dismiss됨. 추후 수정 필요
    @objc private func touchOkButton() {
        self.dismiss(animated: false, completion: nil)
    }
}
