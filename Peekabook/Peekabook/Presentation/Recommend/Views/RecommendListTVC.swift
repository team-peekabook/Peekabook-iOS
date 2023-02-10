//
//  RecommendTableViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

import SnapKit
import Then

final class RecommendListTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    private let bookHeaderView = UIView()
    private let recommendStackView =  UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    private let bookImageContainerView = UIView()
    private let bookCommentsContainerView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    private let bookNameLabel = UILabel().then {
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    private let bookDividerView = UIView()
    private let bookWriterLabel = UILabel().then {
        $0.font = .s3
        $0.textColor = .peekaWhite
    }
    private let bookImage = UIImageView().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.masksToBounds = false
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
    }
    private let bookRecommendedPersonImage = UIImageView().then {
        $0.layer.cornerRadius = 7.5
        $0.clipsToBounds = true
    }
    private let bookRecommendedPersonLabel = UILabel().then {
        $0.font = .s2
        $0.textColor = .peekaRed
    }
    private let bookRecommendDateLabel = UILabel().then {
        $0.font = .c2
        $0.textColor = .peekaRed
    }
    private let bookRecommendTextLabel = UILabel().then {
        $0.font = .s2
        $0.textColor = .peekaRed
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 5,
                left: 0,
                bottom: 5,
                right: 0
            )
        )
    }
}

// MARK: - UI & Layout

extension RecommendListTVC {
    private func setSubviews() {
        contentView.addSubviews(
            [bookHeaderView,
             recommendStackView]
        )
        bookHeaderView.addSubviews([
            bookNameLabel,
            bookDividerView,
            bookWriterLabel
        ])
        recommendStackView.addArrangedSubviews(
            bookImageContainerView,
            bookCommentsContainerView
        )
        bookImageContainerView.addSubview(bookImage)
        bookCommentsContainerView.addSubviews([
            bookRecommendedPersonImage,
            bookRecommendedPersonLabel,
            bookRecommendDateLabel,
            bookRecommendTextLabel
        ])
    }

    private func setUI() {
        self.backgroundColor = .peekaBeige
        bookHeaderView.backgroundColor = .peekaRed
        bookDividerView.backgroundColor = .peekaWhite
        bookImageContainerView.backgroundColor = .peekaWhite
        bookCommentsContainerView.backgroundColor = .peekaWhite
    }
    
    private func setLayout() {
        
        bookHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        bookNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
        }
        
        bookDividerView.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.centerY.equalTo(bookNameLabel)
            make.leading.equalTo(bookNameLabel.snp.trailing).offset(7)
        }
        
        bookWriterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bookDividerView)
            make.leading.equalTo(bookDividerView.snp.trailing).offset(7)
        }
        
        recommendStackView.snp.makeConstraints { make in
            make.top.equalTo(bookHeaderView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        bookImageContainerView.snp.makeConstraints { make in
            make.width.equalTo(122)
        }
        
        bookImage.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalTo(92)
            make.height.equalTo(150)
        }
        
        bookRecommendedPersonImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(14)
            make.width.height.equalTo(15)
        }
        
        bookRecommendedPersonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bookRecommendedPersonImage)
            make.leading.equalTo(bookRecommendedPersonImage.snp.trailing).offset(5)
        }
        
        bookRecommendDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.trailing.equalToSuperview().inset(18)
        }
        
        bookRecommendTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview().inset(13)
        }
    }
}

// MARK: - Methods

extension RecommendListTVC {
    
    func dataBind(model: RecommendBook) {
        bookImage.kf.setImage(with: URL(string: model.bookImage))
        bookImage.kf.indicatorType = .activity
        bookNameLabel.text = model.bookTitle
        bookWriterLabel.text = model.author
        bookRecommendDateLabel.text = model.createdAt
        bookRecommendedPersonImage.kf.indicatorType = .activity
        bookRecommendedPersonImage.kf.setImage(with: URL(string: model.friendImage))
        bookRecommendedPersonLabel.text = model.friendNickname
        bookRecommendTextLabel.text = model.recommendDesc
    }
}
