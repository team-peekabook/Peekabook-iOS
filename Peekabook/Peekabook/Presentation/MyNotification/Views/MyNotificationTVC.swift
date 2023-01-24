//
//  NotificationTVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/07.
//

import UIKit
import SnapKit
import Then

enum AlarmType: CaseIterable {
    case follow
    case recommended
    case addBook
}
final class MyNotificationTVC: UITableViewCell {
    
    // MARK: - UI Components
    
    private let notiContainerView = UIView()
    private let notiImageView = UIImageView().then {
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    private let contentStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalCentering
        $0.spacing = 3
    }
    private let userNameLabel = UILabel().then {
        $0.textColor = .peekaRed
        $0.font = .h1
    }
    private let contentLabel = UILabel().then {
        $0.text = ""
        $0.numberOfLines = 2
        $0.textColor = .peekaRed
        $0.font = .h2
    }
    private let bookNameLabel = UILabel().then {
        $0.textColor = .peekaRed_60
        $0.font = .s3
    }
    private let dateLabel = UILabel().then {
        $0.textColor = .peekaRed_60
        $0.font = .s3
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MyNotificationTVC.className)
        setLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        notiImageView.layer.opacity = 1
        contentLabel.textColor = .peekaRed
        bookNameLabel.textColor = .peekaRed_60
        dateLabel.textColor = .peekaRed_60
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 8,
            right: 0)
        )
    }
}

// MARK: - UI & Layout

extension MyNotificationTVC {
    
    private func setLayout() {
        contentView.addSubviews(notiContainerView)
        backgroundColor = .peekaBeige
        notiContainerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        notiContainerView.addSubviews(
            notiImageView,
            contentStackView,
            dateLabel
        )
        bookNameLabel.snp.makeConstraints { make in
            make.width.equalTo(180)
        }
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
}

// MARK: - dataBind

extension MyNotificationTVC {
    
    func dataBind(model: GetAlarmResponse) {
        if let image = model.profileImage {
            self.notiImageView.kf.indicatorType = .activity
            self.notiImageView.kf.setImage(with: URL(string: image))
        }
        userNameLabel.text = model.senderName
        contentLabel.text = "\(setContentLabel(model: model))"
        bookNameLabel.text = model.bookTitle
        dateLabel.text = model.createdAt
    }
    
    func changeUserNameFont(model: GetAlarmResponse) {
        guard let content = self.contentLabel.text else { return }
        let attributeString = NSMutableAttributedString(string: content)
        let font = UIFont.h1
        attributeString.addAttribute(.font, value: font, range: (content as NSString).range(of: "'\(model.senderName)'"))

        self.contentLabel.attributedText = attributeString
    }
    
    private func setContentLabel(model: GetAlarmResponse) -> String {
        if model.typeID == 1 {
            return "'\(model.senderName)'님이 \(I18N.Alarm.followAlarm)"
        } else if model.typeID == 2 {
            return "'\(model.senderName)'님이\(changeLines(userName: model.senderName))\(I18N.Alarm.recommendAlarm)"
        } else if model.typeID == 3 {
            return "'\(model.senderName)'님의\n\(I18N.Alarm.addBookAlarm)"
        } else {
            return ""
        }
    }
    
    private func changeLines(userName: String) -> String {
        if userName.count > 4 {
            return "\n"
        } else { return " " }
    }
    
    func changeRead() {
        notiImageView.layer.opacity = 0.4
        contentLabel.textColor = .peekaGray2
        bookNameLabel.textColor = .peekaGray2_60
        dateLabel.textColor = .peekaGray2_60
    }
}
