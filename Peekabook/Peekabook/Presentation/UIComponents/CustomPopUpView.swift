//
//  CustomPopUpView.swift
//  Peekabook
//
//  Created by 김인영 on 2023/03/05.
//

import UIKit

final class CustomPopUpView: UIView {
    
    let confirmLabel = UILabel().then {
        $0.text = I18N.BookDelete.popUpComment
        $0.font = .h4
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    lazy var cancelButton = UIButton().then {
        $0.setTitle(I18N.Confirm.cancel, for: .normal)
        $0.titleLabel!.font = .h2
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .peekaGray2
    }
    
    lazy var confirmButton = UIButton().then {
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .peekaRed
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomPopUpView {
    
    private func setUI() {
        backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        addSubviews(confirmLabel, cancelButton, confirmButton)
        
        confirmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(confirmLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(124)
            $0.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(confirmLabel.snp.bottom).offset(14)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(cancelButton)
        }
    }
}
