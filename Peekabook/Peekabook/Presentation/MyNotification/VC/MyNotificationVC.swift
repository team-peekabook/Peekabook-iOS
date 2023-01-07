//
//  MyNotificationVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class MyNotificationVC: UIViewController {
    
    // MARK: - Properties

    var notiDummy: [NotificationModel] = [
        NotificationModel(image: ImageLiterals.Sample.profile4, user: "추천", bookName: "책이름", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile1, user: "뇽잉깅", bookName: "bookName", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile4, user: "인영케이", bookName: "책이름", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile6, user: "샬라샬리샬라", bookName: "", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile2, user: "안녕하세요", bookName: "뷰공장입니다", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile3, user: "추천", bookName: "하하 웃으며 살자", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile4, user: "두두두", bookName: "", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile4, user: "문수선배", bookName: "", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile4, user: "윤수선배", bookName: "수빈은윤수빈", date: "12월 25일"),
        NotificationModel(image: ImageLiterals.Sample.profile4, user: "가나다라마", bookName: "안녕?", date: "12월 2일")
    ]
    
    // MARK: - UI Components
    
    private let headerContainerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.close, for: .normal)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private let notificationLabel = UILabel().then {
        $0.text = I18N.Tabbar.notification
        $0.textColor = UIColor.peekaRed
        $0.font = .h3
    }
    
    private lazy var notificationTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.allowsSelection = false
        $0.allowsMultipleSelection = false
        $0.backgroundColor = UIColor.peekaBeige
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        register()
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - UI & Layout

extension MyNotificationVC {
    
    private func register() {
        notificationTableView.register(MyNotificationTVC.self, forCellReuseIdentifier: MyNotificationTVC.className)
    }
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerContainerView.backgroundColor = UIColor.peekaBeige
        notificationTableView.backgroundColor = UIColor.peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(headerContainerView, notificationTableView)
        headerContainerView.addSubviews(backButton, notificationLabel)
        
        headerContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        backButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }
        
        notificationLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        notificationTableView.snp.makeConstraints { make in
            make.top.equalTo(headerContainerView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension MyNotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiDummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNotificationTVC.className, for: indexPath) as? MyNotificationTVC else { return UITableViewCell() }
        cell.dataBind(model: notiDummy[indexPath.row])
        return cell
    }
}
