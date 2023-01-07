//
//  NotificationTVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/07.
//

import UIKit

class MyNotificationTVC: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MyNotificationTVC.className)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
