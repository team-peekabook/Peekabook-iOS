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
    private let popUpView = CustomPopUpView()
    
    private let personNameLabel = UILabel().then {
        $0.font = .h4
        $0.textColor = .peekaRed
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addTargets()
    }
}

// MARK: - UI & Layout
extension ConfirmPopUpVC {
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        popUpView.backgroundColor = .peekaBeige
        popUpView.confirmLabel.text = personName + I18N.BookProposal.confirm
        popUpView.confirmButton.setTitle(I18N.Confirm.recommend, for: .normal)
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension ConfirmPopUpVC {
    
    private func addTargets() {
        popUpView.cancelButton.addTarget(self, action: #selector(touchCancelButtonDidTap), for: .touchUpInside)
        popUpView.confirmButton.addTarget(self, action: #selector(touchConfirmButtonDipTap), for: .touchUpInside)
    }
    
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
