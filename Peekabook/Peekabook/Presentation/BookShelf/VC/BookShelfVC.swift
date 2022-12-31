//
//  BookShelfVC.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import SnapKit
import Then

import Moya

final class BookShelfVC: UIViewController {
    
    // MARK: - Properties
    let sampleLabel = UILabel().then {
        $0.text = "안녕하세요"
        $0.font = UIFont.font(.notoSansBold, ofSize: 20)
        $0.textColor = .peekaRed
    }

    // MARK: - UI Components

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension BookShelfVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubview(sampleLabel)
        
        sampleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Methods
