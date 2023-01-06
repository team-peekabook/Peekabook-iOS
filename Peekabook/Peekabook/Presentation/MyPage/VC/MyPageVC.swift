//
//  MyPageVC.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import SnapKit
import Then

import Moya

final class MyPageVC: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let naviContainerView = UIView()
    
    private let logoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = ImageLiterals.Image.logo
        $0.clipsToBounds = true
    }
    
    private let horizontalLine = UIView()
    
    private let emptyNotiLabel = UILabel().then {
        $0.text = I18N.Alert.emptyNoti
        $0.font = .h2
        $0.textColor = .peekaRed_60
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

extension MyPageVC {
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
        horizontalLine.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        view.addSubviews(naviContainerView, emptyNotiLabel)
        naviContainerView.addSubviews(logoImage, horizontalLine)
        
        naviContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        horizontalLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        emptyNotiLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods
