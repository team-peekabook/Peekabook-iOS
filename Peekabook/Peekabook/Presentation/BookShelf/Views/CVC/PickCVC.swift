//
//  PickCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

final class PickCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let countBackgroundView = UIView()
    
    private let countLabel = UILabel().then {
        $0.font = .engC
        $0.textColor = .peekaWhite
    }
    
    private let bookNameLabel = UILabel().then {
        $0.font = .h1
        $0.textColor = .peekaRed
        $0.textAlignment = .left
    }
    
    private let horizontalLine1 = UIView()
    
    private let horizontalLine2 = UIView()
    
    private let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let titleContainerView = UIView()

    private let titleLabel = UILabel().then {
        $0.font = .c1
        $0.textColor = .peekaRed
        $0.textAlignment = .left
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension PickCVC {
    
    func initCell(model: SamplePickModel) {
        countLabel.text = String(model.bookId)
        bookImageView.image = model.image
        bookNameLabel.text = model.name
//        titleLabel.text = model.title
    }
    
    private func setUI() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.peekaRed.cgColor
        backgroundColor = .peekaWhite
        countBackgroundView.backgroundColor = .peekaRed
        horizontalLine1.backgroundColor = .peekaRed
        horizontalLine2.backgroundColor = .peekaRed
        titleContainerView.backgroundColor = .peekaWhite_60
        bookImageView.layer.applyShadow(color: .black, alpha: 0.25, x: 1, y: 1, blur: 4, spread: 0)

    }
    
    private func setLayout() {
        addSubviews(countBackgroundView, bookNameLabel, horizontalLine1, bookImageView, titleContainerView, titleLabel)
        
        countBackgroundView.addSubview(countLabel)
        
        countBackgroundView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        countLabel.snp.makeConstraints { make in
            make.center.equalTo(countBackgroundView)
        }
        
        bookNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(countBackgroundView.snp.trailing).offset(8)
            make.centerY.equalTo(countLabel)
        }
        
        horizontalLine1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(countBackgroundView)
            make.height.equalTo(1)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine1.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(116)
            make.height.equalTo(190)
        }
        
        horizontalLine2.snp.makeConstraints { make in

        }
        
        titleContainerView.snp.makeConstraints { make in
            
        }
        
        titleLabel.snp.makeConstraints { make in
            
        }
    }
}