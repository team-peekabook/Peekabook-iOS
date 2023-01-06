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
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private let countLabel = UILabel().then {
        $0.font = .engC
        $0.backgroundColor = .peekaRed
        $0.textColor = .peekaWhite
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
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
        guard let count = model.countLabel else { return }
        bookImageView.image = model.bookImage
        countLabel.text = String(count)
    }
    
    private func setUI() {
        backgroundColor = .yellow
        bookImageView.layer.applyShadow(color: .black, alpha: 0.25, x: 1, y: 1, blur: 4, spread: 0)
    }
    
    private func setLayout() {
        addSubviews(bookImageView, countLabel)
        
        bookImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(20)
        }
    }
}