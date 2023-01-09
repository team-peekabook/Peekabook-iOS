//
//  BookEmptyViewController.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/09.
//

import UIKit

import SnapKit
import Then

import Moya

final class BookEmptyViewController: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    private let emptyView = UIView()
    private let emptyImgView = UIImageView()
    
    private let emptyLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed_60
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
extension BookEmptyViewController {
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        emptyView.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubview(emptyView)
        
        [emptyImgView].forEach {
            emptyView.addSubview($0)
        }
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(247)
            make.height.equalTo(96)
        }
        
        emptyImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImgView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func config() {
        emptyImgView.image = ImageLiterals.Icn.empty
    }
}

// MARK: - Methods
