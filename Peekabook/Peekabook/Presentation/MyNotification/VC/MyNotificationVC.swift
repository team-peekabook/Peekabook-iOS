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
        NotificationModel(image: ImageLiterals.Sample.profile4, notiLabel: "추천", bookName: "책이름", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile4, notiLabel: "추천추천추천추천춫ㄴ러아러ㅏㅇㄴ러미ㅓ랄ㅇㄴㄹㅇㄴㄹ", bookName: "책이름", date: "12월 2일"),
        NotificationModel(image: ImageLiterals.Sample.profile4, notiLabel: "추천", bookName: "책이름", date: "12월 2일")
    ]
    
    // MARK: - UI Components
    
    private let headerContainerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.close, for: .normal)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private let notificationLabel = UILabel().then {
        $0.text = "알림"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private lazy var notificationTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = true
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
        notificationTableView.rowHeight = UITableView.automaticDimension
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
            make.top.equalTo(headerContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension MyNotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNotificationTVC.className, for: indexPath) as? MyNotificationTVC else { return UITableViewCell() }
        cell.dataBind(model: notiDummy[indexPath.row])
        return cell
    }
}
