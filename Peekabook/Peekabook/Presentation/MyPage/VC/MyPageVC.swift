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
        "알림 설정",
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
        myPageTableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.className)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.className, for: indexPath) as? MyPageTableViewCell
        else {
            return UITableViewCell()
        }
        cell.label.text = myPageArray[safe: indexPath.row]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("알림설정")
        case 1:
            print("개인정보 보호 정책")
        case 2:
            print("문의하기")
        case 3:
            print("개발자 정보")
        case 4:
            print("로그아웃")
            let popupViewController = LogoutPopUpVC()
            popupViewController.modalPresentationStyle = .overFullScreen
            self.present(popupViewController, animated: false)
        case 5:
            print("서비스 탈퇴하기")
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageHeaderView.className) as? MyPageHeaderView else { return nil }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 104
    }
}
