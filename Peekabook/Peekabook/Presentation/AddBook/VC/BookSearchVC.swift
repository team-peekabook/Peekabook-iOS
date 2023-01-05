//
//  BookSearchVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/05.
//

import UIKit

import SnapKit
import Then

import Moya

final class BookSearchVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    
    private let headerView = UIView()
    
    private lazy var touchCancelButton = UIButton().then {
        $0.addTarget(self, action: #selector(popToMainView), for: .touchUpInside)
    }
    
    private let headerTitle = UILabel().then {
        $0.text = "책 추천하기"
        $0.font = .h3
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
extension BookSearchVC {
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        
        touchCancelButton.setImage(ImageLiterals.Icn.close, for: .normal)
    }
    
    private func setLayout() {
        [headerView].forEach {
            view.addSubview($0)
        }
        
        [touchCancelButton, headerTitle].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        touchCancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        headerTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension BookSearchVC {
    
    // TODO: - 버튼 액션 구현 필요
    @objc private func popToMainView() {
        // do something
    }
}
