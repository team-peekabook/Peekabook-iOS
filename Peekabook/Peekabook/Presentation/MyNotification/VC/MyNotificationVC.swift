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
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneRightButton)
        .addMiddleLabel(title: I18N.Alarm.notification)
        .addRightButtonAction {
            self.backButtonTapped()
        }
    
    private lazy var notificationTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.allowsSelection = false
        $0.backgroundColor = .peekaBeige
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let emptyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textColor = .peekaRed_60
        label.text = I18N.Alarm.emptyDescription
        return label
    }()
    
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
        notificationTableView.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, notificationTableView, emptyDescriptionLabel)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        notificationTableView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension MyNotificationVC {
    
    private func registerCells() {
        notificationTableView.register(MyNotificationTVC.self, forCellReuseIdentifier: MyNotificationTVC.className)
    }
    
    private func setEmptyView(isEnabled: Bool) {
        emptyDescriptionLabel.isHidden = !isEnabled
        notificationTableView.isHidden = isEnabled
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyNotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = serverGetAlarmData[safe: indexPath.row]!
        if data.senderName.count > 4 && serverGetAlarmData[safe: indexPath.row]!.typeID != 1 {
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
        cell.dataBind(model: serverGetAlarmData[safe: indexPath.row]!)
        cell.changeUserNameFont(model: serverGetAlarmData[safe: indexPath.row]!)

        return cell
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - Network

extension MyNotificationVC {
    private func getAlarmAPI() {
        AlarmAPI(viewController: self).getAlarmAPI { response in
            guard let response = response, let data = response.data else { return }
            self.serverGetAlarmData = data
            self.setEmptyView(isEnabled: data.isEmpty)
            self.notificationTableView.reloadData()
        }
    }
}
