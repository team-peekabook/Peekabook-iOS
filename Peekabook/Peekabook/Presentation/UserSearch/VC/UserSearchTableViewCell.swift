//
//  UserSearchTableViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/05.
//

import UIKit
import SnapKit
import Then

class UserSearchTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = UIColor.peekaGray2
        $0.font = .systemFont(ofSize: 10, weight: .medium)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setSubview()
            setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserSearchTableViewCell {
    
    private func setSubview() {
        
    }
    
    private func setLayout() {
        contentView.addSubviews([nameLabel])
        nameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func dataBind(model: UserSearchModel) {
        nameLabel.text = model.name
    }
}
