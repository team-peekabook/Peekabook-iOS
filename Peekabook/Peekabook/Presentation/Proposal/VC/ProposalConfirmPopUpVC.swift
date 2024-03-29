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

final class ProposalConfirmPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    var recommendDesc: String? = ""
    var bookTitle: String = ""
    var author: String = ""
    var bookImage: String = ""
    var personId: Int = 0
    var personName: String = ""
    var publisher: String = ""

    // MARK: - UI Components
    
    private lazy var confirmPopUpview = CustomPopUpView(frame: .zero, style: .recommend, viewController: self)
    private let personNameLabel = UILabel().then {
        $0.font = .h4
        $0.textColor = .peekaRed
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension ProposalConfirmPopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        confirmPopUpview.backgroundColor = .peekaBeige
        confirmPopUpview.getConfirmLabel(style: .recommend, personName: personName)
    }
    
    private func setLayout() {
        view.addSubview(confirmPopUpview)
        
        confirmPopUpview.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension ProposalConfirmPopUpVC {
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func confirmButtonDidTap() {
        postProposalBook(friendId: personId, param: ProposalBookRequest(recommendDesc: recommendDesc,
                                                                        bookTitle: bookTitle,
                                                                        author: author,
                                                                        bookImage: bookImage,
                                                                        publisher: publisher)
        )
    }
}

// MARK: - Network

extension ProposalConfirmPopUpVC {
    
    private func postProposalBook(friendId: Int, param: ProposalBookRequest) {
        FriendAPI(viewController: self).postProposalBook(friendId: friendId, param: param) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
