//
//  RecommendCollectionViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit
import Then
import SnapKit

final class RecommendCVC: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? .peekaRed : .peekaGray2
        }
    }
    
    private var menuLabel = UILabel().then {
        $0.font = .nameBold
        $0.textColor = .peekaGray2
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendCVC {
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        contentView.addSubview(menuLabel)
        menuLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func dataBind(menuLabel: String) {
        self.menuLabel.text = menuLabel
    }
}
