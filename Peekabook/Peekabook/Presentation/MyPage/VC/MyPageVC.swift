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

    private let myPageArray: [String] = [
        "차단사용자 관리하기",
        "개인정보 보호 정책 & 서비스 이용 약관",
        "문의하기",
        "개발자 정보",
        "로그아웃",
        "서비스 탈퇴하기"
    ]
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .changeLeftBackButtonToLogoImage()

    private lazy var myPageTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .peekaBeige
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
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
        view.addSubviews(naviBar, myPageTableView)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension MyPageVC {
    
    private func registerCells() {
        myPageTableView.register(MyPageTVC.self, forCellReuseIdentifier: MyPageTVC.className)
        myPageTableView.register(
            MyPageHeaderView.self,
            forHeaderFooterViewReuseIdentifier: MyPageHeaderView.className)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTVC.className, for: indexPath) as? MyPageTVC
        else {
            return UITableViewCell()
        }
        cell.label.text = myPageArray[safe: indexPath.row]!
//        cell.selectionStyle = .none
        let bgColorView = UIView()
        bgColorView.backgroundColor = .peekaBlack.withAlphaComponent(0.02)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let manageBlockedUsersVC = ManageBlockedUsersVC()
            manageBlockedUsersVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(manageBlockedUsersVC, animated: true)
        } else {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageHeaderView.className) as? MyPageHeaderView else { return nil }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 104
    }
}
