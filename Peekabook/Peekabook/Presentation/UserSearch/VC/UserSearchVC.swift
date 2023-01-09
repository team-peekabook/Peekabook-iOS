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
        UserSearchModel(
            image: ImageLiterals.Sample.profile3,
            name: "뇽잉깅",
            isFollowing: false
        )
    ]
    
    // MARK: - UI Components
    
    private let headerView = UIView()
    private lazy var backButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.back, for: .normal)
        $0.addTarget(
            self,
            action: #selector(backBtnTapped),
            for: .touchUpInside
        )
    }
    private let searchTitleLabel = UILabel().then {
        $0.text = "사용자 검색하기"
        $0.textColor = .peekaRed
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    private let headerUnderlineView = UIView().then {
        $0.backgroundColor = .peekaRed
    }
    
    private let searchBarContainerView = UIView().then {
        $0.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
    }
    private lazy var searchTextField = UITextField().then {
        $0.placeholder = "사용자의 닉네임을 입력해주세요."
        $0.textColor = .peekaRed
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.autocorrectionType = .no
    }
    
    private lazy var searchBarButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.search, for: .normal)
        $0.addTarget(
            self,
            action: #selector(searchBtnTapped),
            for: .touchUpInside)
    }
    
    private lazy var userSearchTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = true
        $0.isScrollEnabled = true
        $0.allowsSelection = false
        $0.allowsMultipleSelection = false
        $0.backgroundColor = .peekaBeige
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
    
    @objc private func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func searchBtnTapped() {
        print("검색")
    }
}

// MARK: - UI & Layout

extension UserSearchVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(
            [searchBarContainerView,
            userSearchTableView,
            headerView]
        )
        headerView.addSubviews(
            [backButton,
             searchTitleLabel,
             headerUnderlineView]
        )
        searchBarContainerView.addSubviews(
            [searchTextField,
             searchBarButton]
        )
        
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
            make.center.equalToSuperview()
        }
        headerUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        searchBarContainerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
        searchBarButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.height.width.equalTo(48)
        }
        searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(searchBarButton.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        userSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBarContainerView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension UserSearchVC {
    
    private func register() {
        userSearchTableView.register(
            UserSearchTVC.self,
            forCellReuseIdentifier: UserSearchTVC.className
        )
    }
}

// MARK: - Delegate

extension UserSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return userDummy.count
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 178
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserSearchTVC.className,
            for: indexPath
        ) as? UserSearchTVC
        else {
            return UITableViewCell()
        }
        cell.dataBind(model: userDummy[indexPath.row])
        return cell
    }
}
