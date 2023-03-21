//
//  DeclareVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/21.
//

import UIKit

import SnapKit
import Then

import Moya

final class DeclareVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Declare.title)
        .addUnderlineView()
    
    private let containerScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addTapGesture()
    }
}

// MARK: - UI & Layout

extension DeclareVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        
        containerScrollView.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, containerScrollView)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension DeclareVC {
    
    // MARK: - @objc Function
}
