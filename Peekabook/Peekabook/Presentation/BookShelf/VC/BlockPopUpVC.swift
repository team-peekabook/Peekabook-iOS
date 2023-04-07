//
//  BlockPopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/24.
//

import UIKit

import SnapKit
import Then

import Moya

final class BlockPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    var personId: Int = 0
    var personName: String = ""

    // MARK: - UI Components
    
    private lazy var blockPopUpVC = CustomPopUpView(frame: .zero, style: .block, viewController: self)
    private let personNameLabel = UILabel().then {
        $0.font = .h4
        $0.textColor = .peekaRed
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension BlockPopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        blockPopUpVC.backgroundColor = .peekaBeige
        blockPopUpVC.getConfirmLabel(style: .block, personName: personName)
    }
    
    private func setLayout() {
        view.addSubview(blockPopUpVC)
        
        blockPopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(156)
        }
    }
}

// MARK: - Methods

extension BlockPopUpVC {
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func confirmButtonDidTap() {
        postUserReport(friendId: personId)
    }
}

extension BlockPopUpVC {
    private func postUserReport(friendId: Int) {
        FriendAPI.shared.postUserBlock(friendId: friendId) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
