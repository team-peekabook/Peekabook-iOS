//
//  BookInfoTableViewCell.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/06.
//

import SnapKit
import Then

import Moya

class BookInfoTableViewCell: UITableViewCell {
    
    static let identifier = "BookInfoTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components

    private let bookContainerView = UIView()
    private let bookImgView = UIImageView()
    private let bookTitleLabel = UILabel().then {
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private let authorLabel = UILabel().then {
        $0.font = .h2
        $0.textColor = .peekaRed
    }
    
    private let addLabel = UILabel().then {
        $0.font = .c1
        $0.textColor = .peekaRed
    }
    
    private let addButton = UIButton().then {
        $0.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension BookInfoTableViewCell {
    private func setLayout() {
        
    }
    
    func dataBind(model: BookInfoModel) {
        bookTitleLabel.text = model.title
        authorLabel.text = model.author
        bookImgView.image = UIImage(named: model.image)
    }
}
