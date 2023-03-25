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
    case unfollow
    case block
    case declare
}

final class CustomPopUpView: UIView {
    
    private let confirmLabel = UILabel().then {
        $0.font = .h4
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let blockDetailLabel = UILabel().then {
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.font = .s3
    }
    
    private lazy var cancelButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Confirm.cancel, for: .normal)
        $0.titleLabel!.font = .h2
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var confirmButton = UIButton(type: .system).then {
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Initialization
    
    init(frame: CGRect, style: ButtonLabelStyle, viewController: UIViewController) {
        super.init(frame: frame)
        
        setBackgroundColor()
        setLayout(style)
        setButtonStyle(style: style, viewController: viewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomPopUpView {
    
    private func setLayout(_ style: ButtonLabelStyle) {
        addSubviews(confirmLabel, confirmButton)
        self.snp.makeConstraints {
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
        
        switch style {
        case .recommend, .delete, .unfollow:
            self.setTwoButtonLayout()
        case .block:
            self.setTwoButtonAndLabelLayout()
        case .declare:
            self.setOneButtonLayout()
        }
    }
    
    private func setTwoButtonLayout() {
        self.addSubview(cancelButton)
        
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
    
    private func setTwoButtonAndLabelLayout() {
        self.addSubview(blockDetailLabel)
        
        self.snp.updateConstraints {
            $0.height.equalTo(156)
        }
        
        confirmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
        }
        
        blockDetailLabel.snp.makeConstraints {
            $0.top.equalTo(confirmLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }

        cancelButton.snp.makeConstraints {
            $0.top.equalTo(blockDetailLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(124)
            $0.height.equalTo(40)
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(cancelButton)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(cancelButton)
        }
    }
    
    private func setOneButtonLayout() {
        
        confirmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(31)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(confirmLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(263)
            $0.height.equalTo(40)
        }
    }
    
    func getConfirmLabel(style: ButtonLabelStyle, personName: String? = nil) {
        switch style {
        case .recommend:
            if let personName = personName {
                confirmLabel.text = personName + I18N.BookProposal.confirm
            }
        case .delete:
            confirmLabel.text = I18N.BookDelete.popUpComment
        case .unfollow:
            if let personName = personName {
                confirmLabel.text = personName + I18N.FollowStatus.unfollowComment
            }
        case .block:
            if let personName = personName {
                confirmLabel.text = personName + I18N.BlockPopUp.blockComment
            }
        case .declare:
            // StringLiterals 컨플릭트 방지용. 브런치 합친 후 수정
            confirmLabel.text = "신고가 정상적으로 접수되었습니다."
        }
    }
    
    func setButtonStyle(style: ButtonLabelStyle, viewController: UIViewController) {
        switch style {
        case .recommend:
            confirmButton.setTitle(I18N.Confirm.recommend, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(ConfirmPopUpVC.cancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(ConfirmPopUpVC.confirmButtonDidTap), for: .touchUpInside)
        case .delete:
            confirmButton.setTitle(I18N.Confirm.delete, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(DeletePopUpVC.cancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(DeletePopUpVC.confirmButtonDidTap), for: .touchUpInside)
        case .unfollow:
            confirmButton.setTitle(I18N.FollowStatus.unfollow, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(UnfollowPopUpVC.cancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(UnfollowPopUpVC.confirmButtonDidTap), for: .touchUpInside)
        case .block:
            confirmButton.setTitle(I18N.BlockPopUp.block, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(BlockPopUpVC.cancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(BlockPopUpVC.confirmButtonDidTap), for: .touchUpInside)
        case .declare:
            confirmButton.setTitle("홈으로 돌아가기", for: .normal)
            confirmButton.addTarget(viewController, action: #selector(BlockPopUpVC.confirmButtonDidTap), for: .touchUpInside)
        }
    }
    
    private func setBackgroundColor() {
        cancelButton.backgroundColor = .peekaGray2
        confirmButton.backgroundColor = .peekaRed
        backgroundColor = .peekaBeige
    }
}
