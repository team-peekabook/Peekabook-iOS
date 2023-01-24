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
    
    private var serverGetAlarmData: [GetAlarmResponse] = []
    
    // MARK: - UI Components
    
    private let headerContainerView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.close, for: .normal)
        $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private let notificationLabel = UILabel().then {
        $0.text = I18N.Tabbar.notification
        $0.textColor = .peekaRed
        $0.font = .h3
    }
    
    private lazy var notificationTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.allowsSelection = false
        $0.backgroundColor = .peekaBeige
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlarmAPI()
    }
}

// MARK: - UI & Layout

extension MyNotificationVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerContainerView.backgroundColor = .peekaBeige
        notificationTableView.backgroundColor = .peekaBeige
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

extension MyNotificationVC {
    
    private func registerCells() {
        notificationTableView.register(MyNotificationTVC.self, forCellReuseIdentifier: MyNotificationTVC.className)
    }
}

extension MyNotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = serverGetAlarmData[indexPath.row]
        if data.senderName.count > 4 && serverGetAlarmData[indexPath.row].typeID != 1 {
            return 96
        } else if data.typeID == 1 || (data.senderName.count < 5 && data.typeID == 2) {
            return 80
        } else {
            return 96
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverGetAlarmData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNotificationTVC.className,
            for: indexPath) as? MyNotificationTVC
        else {
            return UITableViewCell()
        }
        cell.dataBind(model: serverGetAlarmData[indexPath.row])
        cell.changeUserNameFont(model: serverGetAlarmData[indexPath.row])
        if indexPath.row > 2 {
            cell.changeRead()
        }
        return cell
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - Network

extension MyNotificationVC {
    private func getAlarmAPI() {
        AlarmAPI.shared.getAlarmAPI { response in
            guard let response = response, let data = response.data else { return }
            self.serverGetAlarmData = data
            self.notificationTableView.reloadData()
        }
    }
}
