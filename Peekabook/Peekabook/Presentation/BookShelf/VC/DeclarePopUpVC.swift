//
//  DeclarePopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/25.
//

import UIKit

import SnapKit
import Then

import Moya

final class DeclarePopUpVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var declarePopUpVC = CustomPopUpView(frame: .zero, style: .declare, viewController: self)

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension DeclarePopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        declarePopUpVC.backgroundColor = .peekaBeige
        declarePopUpVC.getConfirmLabel(style: .declare)
    }
    
    private func setLayout() {
        view.addSubview(declarePopUpVC)
        
        declarePopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension DeclarePopUpVC {
    
    @objc func confirmButtonDidTap() {
        print("a")
    }
}
