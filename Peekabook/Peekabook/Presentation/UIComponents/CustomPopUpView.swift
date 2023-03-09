//
//  CustomPopUpView.swift
//  Peekabook
//
//  Created by 김인영 on 2023/03/05.
//

import UIKit

enum ButtonLabelStyle: CaseIterable {
    case recommend
    case delete
}

final class CustomPopUpView: UIView {
    
    private let confirmLabel = UILabel().then {
        $0.font = .h4
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.setTitle(I18N.Confirm.cancel, for: .normal)
        $0.titleLabel!.font = .h2
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var confirmButton = UIButton().then {
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Initialization
    
    init(frame: CGRect, style: ButtonLabelStyle, viewController: UIViewController) {
        super.init(frame: frame)
        
        setBackgroundColor()
        setLayout()
        setButtonStyle(style: style, viewController: viewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomPopUpView {
    
    func getConfirmLabel() -> UILabel {
        return self.confirmLabel
    }
    
    func setButtonStyle(style: ButtonLabelStyle, viewController: UIViewController) {
        switch style {
        case .recommend:
            confirmLabel.text = I18N.BookProposal.confirm
            confirmButton.setTitle(I18N.Confirm.recommend, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(ConfirmPopUpVC.touchCancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(ConfirmPopUpVC.touchConfirmButtonDidTap), for: .touchUpInside)
        case .delete:
            confirmLabel.text = I18N.BookDelete.popUpComment
            confirmButton.setTitle(I18N.Confirm.delete, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(DeletePopUpVC.touchCancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(DeletePopUpVC.touchConfirmButtonDidTap), for: .touchUpInside)
        }
    }
    
    func setBackgroundColor() {
        cancelButton.backgroundColor = .peekaGray2
        confirmButton.backgroundColor = .peekaRed
        backgroundColor = .peekaBeige
    }
    
    func setLayout() {
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
