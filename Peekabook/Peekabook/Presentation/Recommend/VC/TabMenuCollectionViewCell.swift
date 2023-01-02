//
//  TabMenuCollectionViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit
import Then
import SnapKit

class TabMenuCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TabMenuCollectionViewCell"
    
    override var isHighlighted: Bool {
        didSet {
            menuLabel.textColor = isSelected ? .peekaRed : .black
        }
    }
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? .peekaRed : .black
        }
    }
    
    private var menuLabel = UILabel().then {
        $0.text = "book"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TabMenuCollectionViewCell {
    private func setLayout() {
        contentView.addSubview(menuLabel)
        menuLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func dataBind(menuLabel: String) {
        self.menuLabel.text = menuLabel
    }
}
