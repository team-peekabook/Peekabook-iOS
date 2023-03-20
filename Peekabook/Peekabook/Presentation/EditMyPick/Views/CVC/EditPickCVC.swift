//
//  EditPickCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/06.
//

import UIKit

import SnapKit

final class EditPickCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
    private let rankingLabel: UILabel = {
        let lb = UILabel()
        lb.font = .engC
        lb.backgroundColor = .peekaRed
        lb.textColor = .peekaWhite
        lb.clipsToBounds = true
        lb.textAlignment = .center
        lb.layer.cornerRadius = 10
        return lb
    }()
    
    private let horizontalLine: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        return view
    }()
    
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

extension EditPickCVC {
    
    private func setUI() {
        bookImageView.layer.applyShadow(color: .black, alpha: 0.25, x: 1, y: 1, blur: 4, spread: 0)
        horizontalLine.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        addSubviews(bookImageView, rankingLabel, horizontalLine)
        
        bookImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        rankingLabel.snp.makeConstraints {
            $0.top.equalTo(bookImageView).offset(8)
            $0.trailing.equalTo(bookImageView).inset(8)
            $0.width.height.equalTo(20)
        }
        
        horizontalLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bookImageView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width*2)
            $0.height.equalTo(6)
        }
    }
    
    func setData(model: EachBook, pickIndex: Int) {
        bookImageView.kf.indicatorType = .activity
        bookImageView.kf.setImage(with: URL(string: model.bookImage))
        rankingLabel.text = String(pickIndex)
        if pickIndex != -1 {
            selectedLayout(index: pickIndex)
        } else {
            deselectedLayout()
        }
    }
    
    func plusCountLabel(index: Int) {
        rankingLabel.text = String(index + 1)
    }
    
    func selectedLayout(index: Int) {
        bookImageView.layer.opacity = 0.4
        rankingLabel.isHidden = false
        rankingLabel.text = String(index + 1)
    }
    
    func deselectedLayout() {
        bookImageView.layer.opacity = 1
        rankingLabel.isHidden = true
    }
}
