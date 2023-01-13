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
    var recommendDesc: String? = ""
    var bookTitle: String = ""
    var author: String = ""
    var bookImage: String = ""
    var personId: Int = 0

    // MARK: - UI Components
    private let popUpView = UIView()
    
    var personNameLabel = UILabel().then {
        $0.font = .h4
        $0.textColor = .peekaRed
    }
    
    private lazy var confirmLabel = UILabel().then {
        $0.text = "\(personNameLabel.text ?? "사용자")"+I18N.BookProposal.confirm
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
extension ConfirmPopUpViewController {
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        popUpView.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        [confirmLabel, cancelButton, confirmButton].forEach {
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
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(confirmLabel.snp.bottom).offset(14)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(cancelButton)
        }
    }
}

// MARK: - Methods

extension ConfirmPopUpViewController {
    @objc private func touchCancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func touchConfirmButtonDipTap() {
        print(personId)
        
        postProposalBook(friendId: personId, param: ProposalBookRequest(recommendDesc: recommendDesc,
                                                                        bookTitle: bookTitle,
                                                                        author: author,
                                                                        bookImage: bookImage))
    }
}

extension ConfirmPopUpViewController {
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        if animated {
            UIView.transition(with: window, duration: 1.0, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> Void in
                if completion != nil {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
}

extension ConfirmPopUpViewController {
    private func postProposalBook(friendId: Int, param: ProposalBookRequest) {
        FriendAPI.shared.postProposalBook(friendId: friendId, param: param) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
    
}
