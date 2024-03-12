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
    case unblock
    case report
    case logout
    case deleteAccount
    case forceUpdate
    case deleteRecommend
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
    
    private let deleteAccountDetailLabel = UILabel().then {
        $0.text = I18N.DeleteAccount.popUpDetailComment
        $0.textColor = .peekaRed
        $0.font = .h2
    }
    
    private lazy var cancelButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Confirm.cancel, for: .normal)
        $0.titleLabel!.font = .h1
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
            self.setTwoButtonAndTwoLineLabelLayout()
        case .block, .unblock, .deleteRecommend:
            self.setTwoButtonAndDetailLabelLayout()
        case .report:
            self.setOneButtonLayout()
        case .logout:
            self.setTwoButtonAndOneLineLabelLayout()
        case .deleteAccount, .forceUpdate:
            self.setOneButtonAndTwoLineLabelLayout()
        }
    }
    
    private func setTwoButtonAndTwoLineLabelLayout() {
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
    
    private func setTwoButtonAndDetailLabelLayout() {
        self.addSubviews(blockDetailLabel, cancelButton)
        
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
    
    private func setTwoButtonAndOneLineLabelLayout() {
        self.addSubview(cancelButton)
        
        confirmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(confirmLabel.snp.bottom).offset(26)
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
    
    private func setOneButtonAndTwoLineLabelLayout() {
        self.addSubview(deleteAccountDetailLabel)
        changeFontToBold()
        
        confirmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
        }
        
        deleteAccountDetailLabel.snp.makeConstraints {
            $0.top.equalTo(confirmLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(deleteAccountDetailLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(263)
            $0.height.equalTo(40)
        }
    }
    
    private func changeFontToBold() {
        confirmLabel.font = .nameBold
    }
    
    func getConfirmLabel(style: ButtonLabelStyle, personName: String? = nil, detailComment: String? = nil) {
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
                blockDetailLabel.text = I18N.BlockPopUp.blockDetailComment
                changeFontToBold()
            }
        case .unblock:
            if let personName = personName {
                confirmLabel.text = personName + I18N.ManageBlockUsers.unblockPopUpTitle
                blockDetailLabel.text = I18N.ManageBlockUsers.unblockPopSubtitle
                changeFontToBold()
            }
        case .report:
            confirmLabel.text = I18N.Report.reportLabel
        case .logout:
            confirmLabel.text = I18N.Logout.logoutComment
        case .deleteAccount:
            confirmLabel.text = I18N.DeleteAccount.popUpComment
        case .forceUpdate:
            deleteAccountDetailLabel.text = I18N.Update.updateComment
            confirmLabel.text = I18N.Update.update
        case .deleteRecommend:
            if let personName = personName, let detailComment = detailComment {
                confirmLabel.text = personName + I18N.BookRecommend.deleteComment
                blockDetailLabel.text = detailComment
                changeFontToBold()
            }
        }
    }
    
    func setButtonStyle(style: ButtonLabelStyle, viewController: UIViewController) {
        switch style {
        case .recommend:
            confirmButton.setTitle(I18N.Confirm.recommend, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(ProposalConfirmPopUpVC.cancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(ProposalConfirmPopUpVC.confirmButtonDidTap), for: .touchUpInside)
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
        case .unblock:
            confirmButton.setTitle(I18N.ManageBlockUsers.unblock, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(UnblockPopUpVC.cancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(UnblockPopUpVC.confirmButtonDidTap), for: .touchUpInside)
        case .report:
            confirmButton.setTitle(I18N.Report.backTohome, for: .normal)
            confirmButton.addTarget(viewController, action: #selector(BlockPopUpVC.confirmButtonDidTap), for: .touchUpInside)
        case .logout:
            confirmButton.setTitle(I18N.Logout.logout, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(BlockPopUpVC.cancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(BlockPopUpVC.confirmButtonDidTap), for: .touchUpInside)
        case .deleteAccount:
            confirmButton.setTitle(I18N.DeleteAccount.confirm, for: .normal)
            confirmButton.addTarget(viewController, action: #selector(DeleteAccountPopUpVC.confirmButtonDidTap), for: .touchUpInside)
        case .forceUpdate:
            confirmButton.setTitle(I18N.Update.button, for: .normal)
            confirmButton.addTarget(viewController, action: #selector(ForceUpdateVC.confirmButtonDidTap), for: .touchUpInside)
        case .deleteRecommend:
            confirmButton.setTitle(I18N.Confirm.delete, for: .normal)
            cancelButton.addTarget(viewController, action: #selector(RecommendDeletePopUpVC.cancelButtonDidTap), for: .touchUpInside)
            confirmButton.addTarget(viewController, action: #selector(RecommendDeletePopUpVC.confirmButtonDidTap), for: .touchUpInside)
        }
    }
    
    private func setBackgroundColor() {
        cancelButton.backgroundColor = .peekaGray2
        confirmButton.backgroundColor = .peekaRed
        backgroundColor = .peekaBeige
    }
}
