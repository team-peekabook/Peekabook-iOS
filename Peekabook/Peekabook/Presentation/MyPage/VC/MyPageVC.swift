//
//  MyPageVC.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import SnapKit
import Then

import Moya

final class MyPageVC: UIViewController {
    
    // MARK: - Properties

    let myPageArray: [String] = [
        "알림 설정",
        "개인정보 보호 정책 & 서비스 이용 약관",
        "문의하기",
        "개발자 정보",
        "로그아웃",
        "서비스 탈퇴하기"
    ]
    
    // MARK: - UI Components
    
    private let naviContainerView = UIView()
    
    private let logoImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = ImageLiterals.Image.logo
        $0.clipsToBounds = true
    }

    private lazy var myPageTableView = UITableView().then {
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
}

// MARK: - UI & Layout

extension MyPageVC {
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(naviContainerView, myPageTableView)
        naviContainerView.addSubviews(logoImage)
        
        naviContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        myPageTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(naviContainerView.snp.bottom)
        }
    }
}

// MARK: - Methods

extension MyPageVC {
    
    private func registerCells() {
       myPageTableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.className)
    }
}

extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.className, for: indexPath) as? MyPageTableViewCell
        else {
            return UITableViewCell()
        }
        cell.label.text = myPageArray[indexPath.row]
        return cell
    }
}

// MARK: - Network
