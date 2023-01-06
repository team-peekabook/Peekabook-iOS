//
//  BookInfoTableViewCell.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/06.
//

import UIKit

import SnapKit
import Then

import Moya

class BookInfoTableViewCell: UITableViewCell {
    
    static let identifier = "BookInfoTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components

    private let containerView = UIView().then {
        $0.backgroundColor = UIColor.peekaWhite
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    
    private let imgContainerView = UIView()
    private let bookImgView = UIImageView()
    private let labelContainerView = UIView()
    private let addContainerView = UIView()
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
    private func setUI() {
        
    }
    private func setLayout() {
        self.backgroundColor = .white
//        containerView.addSubviews([
//            imgContainerView,
//            labelContainerView,
//            addContainerView
//        ])
//
//        imgContainerView.addSubview(bookImgView)
//
//        labelContainerView.addSubviews([
//            bookTitleLabel,
//            authorLabel
//        ])
//
//        addContainerView.addSubviews([
//            addLabel,
//            addButton
//        ])
        
        contentView.addSubview(containerView)
        
        [imgContainerView, labelContainerView, addContainerView].forEach {
            containerView.addSubview($0)
        }
        
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
            make.height.equalTo(128)
        }
        
        imgContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        labelContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(imgContainerView.snp.trailing)
            make.trailing.equalToSuperview()
            make.height.equalTo(99)
        }
        
        bookTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(bookTitleLabel.snp.bottom)
            make.leading.equalTo(bookTitleLabel)
        }
        
        addContainerView.snp.makeConstraints { make in
            make.top.equalTo(labelContainerView.snp.bottom)
            make.leading.trailing.equalTo(labelContainerView)
            make.width.equalTo(labelContainerView)
            make.height.equalTo(29)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(30)
        }
        
        addLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(addButton.snp.leading).inset(4)
        }
    }
    
    func dataBind(model: BookInfoModel) {
        bookTitleLabel.text = model.title
        authorLabel.text = model.author
        bookImgView.image = UIImage(named: model.image)
    }
    
    @objc
    private func addButtonDidTap() {
        // dosomething
    }
}
