//
//  UserSearchVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class UserSearchVC: UIViewController {
    
    // MARK: - Properties
    
    private let userDummy: [UserSearchModel] = [
        UserSearchModel(name: "뇽잉깅"),
        UserSearchModel(name: "두두"),
        UserSearchModel(name: "윤수선배")
    ]
    
    // MARK: - UI Components
    
    private let headerView = UIView()
    private let backButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.back, for: .normal)
    }
    private let searchTitleLabel = UILabel().then {
        $0.text = "사용자 검색하기"
        $0.textColor = UIColor.peekaRed
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    private let headerUnderlineView = UIView().then {
        $0.backgroundColor = UIColor.peekaRed
    }
    
    private lazy var userSearchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.placeholder = "검색하셈"
        $0.sizeToFit()
        $0.isTranslucent = false
        $0.delegate = self
    }
    
    private lazy var userSearchTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = true
        $0.isScrollEnabled = true
        $0.allowsSelection = false
        $0.allowsMultipleSelection = false
        $0.backgroundColor = UIColor.peekaBeige
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
}

// MARK: - UI & Layout

extension UserSearchVC {
    
    private func setUI() {
        self.view.backgroundColor = UIColor.peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews([userSearchBar,
                          userSearchTableView,
                          headerView])
        headerView.addSubviews([backButton, searchTitleLabel, headerUnderlineView])
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.width.height.equalTo(48)
        }
        searchTitleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        headerUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        userSearchBar.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        userSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(userSearchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension UserSearchVC {
    
    private func register() {
        userSearchTableView.register(UserSearchTableViewCell.self, forCellReuseIdentifier: UserSearchTableViewCell.className)
    }
}

// MARK: - Delegate

extension UserSearchVC: UISearchBarDelegate {
    
}

extension UserSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchTableViewCell.className, for: indexPath) as? UserSearchTableViewCell else { return UITableViewCell() }
        cell.dataBind(model: userDummy[indexPath.row])
        return cell
    }
}
