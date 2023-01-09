//
//  NotificationTVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/07.
//

import UIKit

class MyNotificationTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    private let notiContainerView = UIView()
    private let notiImageView = UIImageView().then {
        $0.image = ImageLiterals.Sample.profile1
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    private let contentStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalCentering
        $0.spacing = 3
    }
    private let userNameLabel = UILabel().then {
        $0.text = "이름"
        $0.textColor = .peekaRed
        $0.font = .h1
    }
    private let contentLabel = UILabel().then {
        $0.text = "'누가누가' 추천을 했답니다"
        $0.numberOfLines = 2
        $0.textColor = .peekaRed
        $0.font = .h2
    }
    private let bookNameLabel = UILabel().then {
        $0.text = "책 이름"
        $0.textColor = .peekaRed_60
        $0.font = .s3
    }
    private let dateLabel = UILabel().then {
        $0.text = "12월 1일"
        $0.textColor = .peekaRed_60
        $0.font = .s3
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MyNotificationTVC.className)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
}

// MARK: - UI & Layout

extension MyNotificationTVC {
    
    private func setLayout() {
        contentView.addSubviews(notiContainerView)
        backgroundColor = .peekaBeige
        notiContainerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        notiContainerView.addSubviews()
        notiContainerView.addSubviews(notiImageView, contentStackView, dateLabel)
        contentStackView.addArrangedSubviews(contentLabel, bookNameLabel)
        notiContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        notiImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(48)
        }
        contentStackView.snp.makeConstraints { make in
            make.leading.equalTo(notiImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        dateLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(12)
        }
    }
    
    func changeRead(model: NotificationModel) {
        notiContainerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        notiImageView.layer.opacity = 0.4
        contentLabel.textColor = .peekaGray2
        bookNameLabel.textColor = .peekaGray2_60
        dateLabel.textColor = .peekaGray2
    }
}

// MARK: - dataBind

extension MyNotificationTVC {
    
    func dataBind(model: NotificationModel) {
        notiImageView.image = model.image
        userNameLabel.text = model.user
        contentLabel.text = "'\(model.user)'님이\(changeLines(userName: model.user)) 이 책을 추천했어요"
        bookNameLabel.text = model.bookName
        dateLabel.text = model.date
    }
    
    func changeUserNameFont(model: NotificationModel) {
        guard let content = self.contentLabel.text else { return }
        let attributeString = NSMutableAttributedString(string: content)
        let font = UIFont.h1
        attributeString.addAttribute(.font, value: font, range: (content as NSString).range(of: "'\(model.user)'"))

        self.contentLabel.attributedText = attributeString
    }
    
    private func changeLines(userName: String) -> String {
        if userName.count > 4 {
            return "\n"
        } else { return "" }
    }
}
