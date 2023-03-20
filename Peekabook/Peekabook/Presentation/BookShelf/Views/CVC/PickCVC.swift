//
//  PickCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

final class PickCVC: UICollectionViewCell {
    
    // MARK: - Properties

    private var bookId: Int = 0
    
    // MARK: - UI Components
    
    private let rankingBackgroundView = UIView()
    
    private let rankingLabel = UILabel().then {
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

// MARK: - UI & Layout

extension PickCVC {
    
    private func setUI() {
        self.clipsToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.peekaRed.cgColor
        backgroundColor = .peekaWhite
        rankingBackgroundView.backgroundColor = .peekaRed
        horizontalLine.backgroundColor = .peekaRed
        titleContainerView.backgroundColor = .peekaWhite_60
        titleContainerView.layer.borderColor = UIColor.peekaRed.cgColor
        titleContainerView.layer.borderWidth = 1
        bookImageView.layer.applyShadow(color: .black, alpha: 0.25, x: 1, y: 1, blur: 4, spread: 0)
    }
    
    private func setLayout() {
        contentView.addSubviews(rankingBackgroundView, bookNameLabel, horizontalLine, bookImageView, titleContainerView)
        titleContainerView.addSubview(titleLabel)
        rankingBackgroundView.addSubview(rankingLabel)
        
        rankingBackgroundView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.center.equalTo(rankingBackgroundView)
        }
        
        bookNameLabel.snp.makeConstraints {
            $0.leading.equalTo(rankingBackgroundView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalTo(rankingLabel)
        }
        
        horizontalLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(rankingBackgroundView)
            $0.height.equalTo(1)
        }
        
        bookImageView.snp.makeConstraints {
            $0.top.equalTo(horizontalLine.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(116)
            $0.height.equalTo(190)
        }
        
        titleContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        checkSmallLayout()
    }
}

// MARK: - Methods

extension PickCVC {
    
    private func checkSmallLayout() {
        if UIScreen.main.isSmallThan712pt {
            bookImageView.snp.updateConstraints {
                $0.width.equalTo(92)
                $0.height.equalTo(152)
            }
        }
    }
    
    func setData(model: Pick) {
        titleContainerView.isHidden = (model.description?.count) == 0 || model.description == nil
        
        rankingLabel.text = String(model.pickIndex)
        bookId = model.book.id
        bookNameLabel.text = model.book.bookTitle
        bookImageView.kf.indicatorType = .activity
        bookImageView.kf.setImage(with: URL(string: model.book.bookImage))
        titleLabel.text = model.description
    }
}
