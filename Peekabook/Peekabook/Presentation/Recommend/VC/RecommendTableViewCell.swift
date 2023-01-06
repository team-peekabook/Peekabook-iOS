//
//  RecommendTableViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

import SnapKit
import Then

final class RecommendTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    
    private let bookHeaderView = UIView().then {
        $0.backgroundColor = UIColor.peekaRed
    }
    
    private let recommendStackView =  UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    private let bookImageContainerView = UIView().then {
        $0.backgroundColor = UIColor.peekaWhite
    }
    private let bookCommentsContainerView = UIView().then {
        $0.backgroundColor = UIColor.peekaWhite
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    private let bookNameLabel = UILabel().then {
        $0.text = "책 이름"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor.peekaWhite
    }
    private let bookDividerLabel = UILabel().then {
        $0.text = "|"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor.peekaWhite
    }
    private let bookWriterLabel = UILabel().then {
        $0.text = "작가"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = UIColor.peekaWhite
    }
    private let bookImage = UIImageView().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.masksToBounds = false
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
    }
    private let bookRecommendedPersonImage = UIImageView().then {
        $0.layer.cornerRadius = 50
    }
    private let bookRecommendedPersonLabel = UILabel().then {
        $0.text = "인영케이"
        $0.font = .systemFont(ofSize: 10, weight: .medium)
        $0.textColor = UIColor.peekaRed
    }
    private let bookRecommendDateLabel = UILabel().then {
        $0.text = "2022.12.25"
        $0.font = .systemFont(ofSize: 9, weight: .medium)
        $0.textColor = UIColor.peekaRed
    }
    
    private let bookRecommendTextLabel = UILabel().then {
        $0.numberOfLines = 8
        $0.text = "추천문구샬라샬라"
        $0.font = .systemFont(ofSize: 10, weight: .medium)
        $0.textColor = UIColor.peekaRed
    }
    
    private lazy var toFriendBookShelfButton = UIButton().then {
        $0.backgroundColor = UIColor.peekaWhite
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.peekaRed.cgColor
        $0.setTitle("\(bookRecommendedPersonLabel.text ?? "누구세요")님의 책장 보러가기 →", for: .normal)
        $0.setTitleColor(UIColor.peekaRed, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 10, weight: .bold)
        $0.contentHorizontalAlignment = .right
        $0.contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 12)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
    }
}

extension RecommendTableViewCell {
    private func addSubview() {
        contentView.addSubviews([bookHeaderView, recommendStackView])
        bookHeaderView.addSubviews([
            bookNameLabel,
            bookDividerLabel,
            bookWriterLabel
        ])
        recommendStackView.addArrangedSubviews(bookImageContainerView, bookCommentsContainerView)
        bookCommentsContainerView.addSubview(toFriendBookShelfButton)
        bookImageContainerView.addSubview(bookImage)
        bookCommentsContainerView.addSubviews([
            bookRecommendedPersonImage,
            bookRecommendedPersonLabel,
            bookRecommendDateLabel,
            bookRecommendTextLabel
        ])
    }

    private func setLayout() {
        self.backgroundColor = UIColor.peekaBeige
        
        bookHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        bookNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
        }
        bookDividerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bookNameLabel)
            make.leading.equalTo(bookNameLabel.snp.trailing).offset(7)
        }
        bookWriterLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bookDividerLabel)
            make.leading.equalTo(bookDividerLabel.snp.trailing).offset(7)
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
            make.top.equalTo(bookRecommendedPersonImage)
            make.leading.equalTo(bookRecommendedPersonImage.snp.trailing).offset(5)
        }
        bookRecommendDateLabel.snp.makeConstraints { make in
            make.top.equalTo(bookRecommendedPersonLabel)
            make.trailing.equalToSuperview().inset(18)
        }
        bookRecommendTextLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        toFriendBookShelfButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(29)
        }
    }
    
    private func changeNameToButton(name: String) {
        toFriendBookShelfButton.setTitle("\(name)님의 책장 보러가기 →", for: .normal)
    }
    
    func dataBind(model: RecommendModel) {
        bookImage.image = model.image
        bookNameLabel.text = model.bookName
        bookWriterLabel.text = model.writer
        bookRecommendedPersonImage.image = model.recommendedPersonImage
        bookRecommendedPersonLabel.text = model.recommendedPerson
        bookRecommendTextLabel.text = model.memo
        changeNameToButton(name: model.recommendedPerson)
    }
}
