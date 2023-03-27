//
//  UnfollowPopUpViewController.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/24.
//

import UIKit

import SnapKit
import Then

import Moya

final class UnfollowPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    var personName: String = ""

    // MARK: - UI Components
    
    private lazy var unfollowCustomPopUpView = CustomPopUpView(frame: .zero, style: .unfollow, viewController: self)
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
extension UnfollowPopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        unfollowCustomPopUpView.backgroundColor = .peekaBeige
        unfollowCustomPopUpView.getConfirmLabel(style: .unfollow, personName: personName)
    }
    
    private func setLayout() {
        view.addSubview(unfollowCustomPopUpView)
        
        unfollowCustomPopUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension UnfollowPopUpVC {
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func confirmButtonDidTap() {
        print("a")
    }
}
