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

    // MARK: - UI Components
    private let popUpView = UIView().then {
        $0.backgroundColor = .peekaBeige
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
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        popUpView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(295)
            make.height.equalTo(136)
        }
    }
}

// MARK: - Methods
