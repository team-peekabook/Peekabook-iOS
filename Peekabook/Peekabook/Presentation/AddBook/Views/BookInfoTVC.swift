//
//  BookInfoTVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/06.
//

import UIKit

import Kingfisher
import SnapKit
import Then

import Moya

final class BookInfoTVC: UITableViewCell {
    
    var bookShelfType: BookShelfType?

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
        $0.font = UIFont.font(.notoSansBold, ofSize: 15)
        $0.textColor = .peekaRed
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let authorLabel = UILabel().then {
        $0.font = .s1
        $0.textColor = .peekaRed
        $0.lineBreakMode = .byTruncatingTail
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

extension BookInfoTVC {
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
        
        imgContainerView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(106)
        }
        
        bookImgView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(61)
            $0.height.equalTo(100)
        }
        
        labelContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(imgContainerView.snp.trailing).offset(-1)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(99)
        }
        
        bookTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.width.equalTo(199)
        }
        
        authorLabel.snp.makeConstraints {
            $0.top.equalTo(bookTitleLabel.snp.bottom)
            $0.leading.equalTo(bookTitleLabel)
            $0.width.equalTo(199)
        }
        
        addContainerView.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom)
            $0.leading.trailing.equalTo(labelContainerView)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(29)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        
        addLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(addButton.snp.leading).offset(-4)
        }
    }
    
    private func config() {
        addButton.setImage(ImageLiterals.Icn.addBookMini, for: .normal)
    }
    
    func dataBind(model: BookInfoModel, bookShelfType: BookShelfType) {
        self.bookShelfType = bookShelfType
        bookTitleLabel.text = model.title
        authorLabel.text = model.author.replacingOccurrences(of: "^", with: ", ")
        let url = URL(string: model.image)!
        bookImgView.kf.indicatorType = .activity
        bookImgView.kf.setImage(with: url)
        
        switch bookShelfType {
        case .user:
            addLabel.text = I18N.BookSearch.addMyBookshelf
        case .friend:
            addLabel.text = I18N.BookSearch.recommendFriendBookShelf
        }
    }
}
