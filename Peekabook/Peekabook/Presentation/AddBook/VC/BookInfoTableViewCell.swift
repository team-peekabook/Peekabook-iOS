//
//  BookInfoTableViewCell.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/06.
//

import UIKit

import Kingfisher
import SnapKit
import Then

import Moya

class BookInfoTableViewCell: UITableViewCell {
    
    static let identifier = "BookInfoTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let imgContainerView = UIView()
    private let bookImgView = UIImageView().then {
        $0.layer.masksToBounds = false
        $0.layer.applyShadow(color: .black, alpha: 0.25, x: 1, y: 1, blur: 4, spread: 0)
        $0.contentMode = .scaleAspectFit
    }
    
    private let labelContainerView = UIView()
    private let addContainerView = UIView()
    private let bookTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.lineBreakMode = .byWordWrapping
        $0.font = UIFont.font(.notoSansBold, ofSize: 15)
        $0.textColor = .peekaRed
    }
    
    private let authorLabel = UILabel().then {
        $0.font = .s1
        $0.textColor = .peekaRed
    }
    
    private let addLabel = UILabel().then {
        $0.font = .c1
        $0.textColor = .peekaRed
        $0.text = "내 책장에 추가하기"
    }
    
    private let addButton = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension BookInfoTableViewCell {
    private func setUI() {
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.peekaRed.cgColor
        imgContainerView.layer.borderWidth = 1
        imgContainerView.layer.borderColor = UIColor.peekaRed.cgColor
        
        labelContainerView.layer.borderWidth = 1
        labelContainerView.layer.borderColor = UIColor.peekaRed.cgColor
    }
    
    private func setLayout() {
        self.backgroundColor = .clear
        contentView.addSubviews([
            imgContainerView,
            labelContainerView,
            addContainerView
        ])
    
        imgContainerView.addSubview(bookImgView)
        
        [bookTitleLabel, authorLabel].forEach {
            labelContainerView.addSubview($0)
        }
        
        [addLabel, addButton].forEach {
            addContainerView.addSubview($0)
        }
        
        imgContainerView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(106)
        }
        
        bookImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(61)
            make.height.equalTo(100)
        }
        
        labelContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imgContainerView.snp.trailing).offset(-1)
            make.trailing.equalToSuperview()
            make.height.equalTo(99)
        }
        
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(199)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom)
            make.leading.equalTo(bookTitleLabel)
        }
        
        addContainerView.snp.makeConstraints { make in
            make.top.equalTo(labelContainerView.snp.bottom)
            make.leading.trailing.equalTo(labelContainerView)
            make.bottom.equalToSuperview()
            make.height.equalTo(29)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        
        addLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(addButton.snp.leading).offset(-4)
        }
    }
    
    private func config() {
        addButton.setImage(ImageLiterals.Icn.addBookMini, for: .normal)
    }
    
    func dataBind(model: BookInfoModel) {
        bookTitleLabel.text = model.title
        authorLabel.text = model.author
        let url = URL(string: model.image)!
        bookImgView.kf.indicatorType = .activity
        bookImgView.kf.setImage(with: url)
    }
}
