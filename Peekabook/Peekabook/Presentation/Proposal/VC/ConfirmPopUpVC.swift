//
//  ConfirmPopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/04.
//

import UIKit

import SnapKit
import Then

import Moya

final class ConfirmPopUpVC: UIViewController {
    
    // MARK: - Properties
    var recommendDesc: String? = ""
    var bookTitle: String = ""
    var author: String = ""
    var bookImage: String = ""
    var personId: Int = 0
    var personName: String = ""

    // MARK: - UI Components
    private let popUpView = UIView()
    
    private let personNameLabel = UILabel().then {
        $0.font = .h4
        $0.textColor = .peekaRed
    }
    
    private let confirmLabel = UILabel().then {
        $0.font = .h4
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.setTitle(I18N.Confirm.cancel, for: .normal)
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .peekaGray2
        $0.addTarget(self, action: #selector(touchCancelButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var confirmButton = UIButton().then {
        $0.setTitle(I18N.Confirm.recommend, for: .normal)
        $0.titleLabel!.font = .h1
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .peekaRed
        $0.addTarget(self, action: #selector(touchConfirmButtonDipTap), for: .touchUpInside)
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension ConfirmPopUpVC {
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        popUpView.backgroundColor = .peekaBeige
        confirmLabel.text = personName + I18N.BookProposal.confirm
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        [confirmLabel, cancelButton, confirmButton].forEach {
            popUpView.addSubview($0)
        }
        
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
        
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

// MARK: - Methods

extension ConfirmPopUpVC {
    @objc private func touchCancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func touchConfirmButtonDipTap() {
        postProposalBook(friendId: personId, param: ProposalBookRequest(recommendDesc: recommendDesc,
                                                                        bookTitle: bookTitle,
                                                                        author: author,
                                                                        bookImage: bookImage))
    }
}

// MARK: - Network

extension ConfirmPopUpVC {
    private func postProposalBook(friendId: Int, param: ProposalBookRequest) {
        FriendAPI.shared.postProposalBook(friendId: friendId, param: param) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
