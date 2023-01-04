//
//  RecommendCollectionViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit
import Then
import SnapKit

class RecommendCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? UIColor.peekaRed : UIColor.peekaGray2
        }
    }
    
    private var menuLabel = UILabel().then {
        $0.text = "book"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = UIColor.peekaGray2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendCollectionViewCell {
    private func setLayout() {
        contentView.addSubview(menuLabel)
        menuLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func dataBind(menuLabel: String) {
        self.menuLabel.text = menuLabel
    }
}
