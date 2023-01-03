//
//  RecommendTableViewCell.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit
import Then
import SnapKit

class RecommendTableViewCell: UITableViewCell {
    
    static let identifier = "RecommendTableViewCell"
    
    // MARK: - UI Components
    
    private let bookHeaderView = UIView().then {
        $0.backgroundColor = .peekaRed
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
        $0.backgroundColor = .peekaWhite
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    private let bookNameLabel = UILabel().then {
        $0.text = "책 이름"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .peekaWhite
    }
    private let bookDividerLabel = UILabel().then {
        $0.text = "|"
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .peekaWhite
    }
    private let bookWriterLabel = UILabel().then {
        $0.text = "작가"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .peekaWhite
    }
    
    private let bookImage = UIImageView().then {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.masksToBounds = false
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
    }
    
    private let bookRecommendToLabel = UILabel().then {
        $0.text = "인영케이"
        $0.font = .systemFont(ofSize: 10, weight: .medium)
        $0.textColor = .peekaRed
    }
    private let bookRecommendDateLabel = UILabel().then {
        $0.text = "2022.12.25"
        $0.font = .systemFont(ofSize: 9, weight: .medium)
        $0.textColor = .peekaRed
    }
    
    private let bookRecommendTextLabel = UILabel().then {
        $0.numberOfLines = 8
        $0.text = "추천문구샬라샬라"
        $0.font = .systemFont(ofSize: 10, weight: .medium)
        $0.textColor = .peekaRed
    }
    
    private lazy var toFriendBookShelfButton = UIButton().then {
        $0.backgroundColor = .peekaWhite
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.peekaRed.cgColor
        $0.setTitle("\(bookRecommendToLabel.text ?? "누구세요")님의 책장 보러가기 →", for: .normal)
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
    func addSubview() {
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
            bookRecommendToLabel,
            bookRecommendDateLabel,
            bookRecommendTextLabel
        ])
    }

    func setLayout() {
        self.backgroundColor = .peekaBeige
        
        bookHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        bookNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(15)
        }
        bookDividerLabel.snp.makeConstraints {
            $0.centerY.equalTo(bookNameLabel)
            $0.leading.equalTo(bookNameLabel.snp.trailing).offset(7)
        }
        bookWriterLabel.snp.makeConstraints {
            $0.centerY.equalTo(bookDividerLabel)
            $0.leading.equalTo(bookDividerLabel.snp.trailing).offset(7)
        }
        recommendStackView.snp.makeConstraints {
            $0.top.equalTo(bookHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        bookImageContainerView.snp.makeConstraints {
            $0.width.equalTo(122)
        }
        bookImage.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.width.equalTo(92)
            $0.height.equalTo(150)
        }
        bookRecommendToLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(14)
        }
        bookRecommendDateLabel.snp.makeConstraints {
            $0.top.equalTo(bookRecommendToLabel)
            $0.trailing.equalToSuperview().inset(18)
        }
        bookRecommendTextLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        toFriendBookShelfButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(29)
        }
    }
    
    func changeNameToButton(name: String) {
        toFriendBookShelfButton.setTitle("\(name)님의 책장 보러가기 →", for: .normal)
    }
    
    func dataBind(model: RecommendModel) {
        bookImage.image = model.image
        bookNameLabel.text = model.name
        bookWriterLabel.text = model.writer
        bookRecommendToLabel.text = model.recommendedTo
        bookRecommendTextLabel.text = model.memo
        changeNameToButton(name: model.recommendedTo)
    }
}
