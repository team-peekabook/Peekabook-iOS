//
//  EditPickCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/06.
//

import UIKit

final class EditPickCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let bookImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private let countLabel = UILabel().then {
        $0.font = .engC
        $0.backgroundColor = .peekaRed
        $0.textColor = .peekaWhite
        $0.clipsToBounds = true
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
    }
    
    private let horizontalLine = UIView().then {
        $0.clipsToBounds = false
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

extension EditPickCVC {
    func initCell(model: SampleEditPickModel) {
        bookImageView.image = model.bookImage
        countLabel.text = String(model.countLabel)
    }
    
    private func setUI() {
        bookImageView.layer.applyShadow(color: .black, alpha: 0.25, x: 1, y: 1, blur: 4, spread: 0)
        horizontalLine.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        addSubviews(bookImageView, countLabel, horizontalLine)
        
        bookImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImageView).offset(8)
            make.trailing.equalTo(bookImageView).inset(8)
            make.width.height.equalTo(20)
        }
        
        horizontalLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bookImageView.snp.bottom)
            make.width.equalTo(UIScreen.main.bounds.width*2)
            make.height.equalTo(6)
        }
    }
    
    func selectedLayout(model: SampleEditPickModel) {
        if countLabel.text != "0" {
            bookImageView.layer.opacity = 0.4
            countLabel.isHidden = false
        } else {
            bookImageView.layer.opacity = 1
            countLabel.isHidden = true
        }
    }
    
    func setData(model: EachBook, pickIndex: Int) {
        bookImageView.kf.setImage(with: URL(string: model.bookImage))
        countLabel.text = String(pickIndex)
    }
}
