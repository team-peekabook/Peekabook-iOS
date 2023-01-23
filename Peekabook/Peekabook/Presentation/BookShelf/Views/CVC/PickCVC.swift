//
//  PickCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

final class PickCVC: UICollectionViewCell {
    
    // MARK: - Protocols

    private var bookId: Int = 0
    
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
    
    private let horizontalLine = UIView()
    
    private let bookImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    private let titleContainerView = UIView()

    private let titleLabel = UILabel().then {
        $0.font = .c1
        $0.textColor = .peekaRed
        $0.textAlignment = .left
        $0.numberOfLines = 3
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
    
    private func setUI() {
        self.clipsToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.peekaRed.cgColor
        backgroundColor = .peekaWhite
        countBackgroundView.backgroundColor = .peekaRed
        horizontalLine.backgroundColor = .peekaRed
        titleContainerView.backgroundColor = .peekaWhite_60
        titleContainerView.layer.borderColor = UIColor.peekaRed.cgColor
        titleContainerView.layer.borderWidth = 1
        bookImageView.layer.applyShadow(color: .black, alpha: 0.25, x: 1, y: 1, blur: 4, spread: 0)
    }
    
    private func setLayout() {
        contentView.addSubviews(countBackgroundView, bookNameLabel, horizontalLine, bookImageView, titleContainerView)
        titleContainerView.addSubview(titleLabel)
        
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
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalTo(countLabel)
        }
        
        horizontalLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(countBackgroundView)
            make.height.equalTo(1)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.top.equalTo(horizontalLine.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(116)
            make.height.equalTo(190)
        }
        
        titleContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func setData(model: Pick) {
        titleContainerView.isHidden = (model.description?.count) == 0
        
        countLabel.text = String(model.pickIndex)
        bookId = model.book.id
        bookNameLabel.text = model.book.bookTitle
        bookImageView.kf.indicatorType = .activity
        bookImageView.kf.setImage(with: URL(string: model.book.bookImage))
        titleLabel.text = model.description
    }
}
