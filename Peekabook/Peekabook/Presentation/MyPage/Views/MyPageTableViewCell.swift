//
//  MyPageTableViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/14.
//

import UIKit
import SnapKit
import Then

final class MyPageTableViewCell: UITableViewCell {

    var label = UILabel().then {
        $0.font = .h2
        $0.textColor = .black
    }
    
    private let underLineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MyPageTableViewCell.className)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyPageTableViewCell {
    
    private func setLayout() {
        underLineView.backgroundColor = .peekaGray1
        backgroundColor = .peekaBeige
        contentView.addSubviews(label, underLineView)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
