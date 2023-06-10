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
import SafariServices

enum MyPageOption {
    case manageBlockUsers
    case privacyPolicy
    case contactUs
    case developerInfo
    case logout
    case deleteAccount
    
    var rawValue: String {
        switch self {
        case .manageBlockUsers:
            return I18N.ManageBlockUsers.manageBlockedUsers
        case .privacyPolicy:
            return I18N.MyPageOption.privacyPolicy
        case .contactUs:
            return I18N.MyPageOption.contactUs
        case .developerInfo:
            return I18N.MyPageOption.developerInfo
        case .logout:
            return I18N.MyPageOption.logout
        case .deleteAccount:
            return I18N.MyPageOption.deleteAccount
        }
    }
}

final class MyPageVC: UIViewController {
    
    // MARK: - UI Components
    
    private let optionArray: [MyPageOption] = [.manageBlockUsers, .privacyPolicy, .contactUs, .developerInfo, .logout, .deleteAccount]
    var getAccountData: GetAccountResponse?
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAccountAPI()
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTVC.className, for: indexPath) as? MyPageTVC
        else {
            return UITableViewCell()
        }
        cell.label.text = optionArray[safe: indexPath.row]!.rawValue
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch optionArray[safe: indexPath.row]! {
        case .manageBlockUsers:
            let manageBlockUsersVC = ManageBlockUsersVC()
            manageBlockUsersVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(manageBlockUsersVC, animated: true)
        case .privacyPolicy:
            let safariViewController = SFSafariViewController(url: URL(string: ExternalURL.Login.privacyPolicy)!)
            self.present(safariViewController, animated: true)
        case .contactUs:
            let safariViewController = SFSafariViewController(url: URL(string: ExternalURL.MyPage.contact)!)
            self.present(safariViewController, animated: true)
        case .developerInfo:
            let safariViewController = SFSafariViewController(url: URL(string: ExternalURL.MyPage.developerInfo)!)
            self.present(safariViewController, animated: true)
        case .logout:
            let popupViewController = LogoutPopUpVC()
            popupViewController.modalPresentationStyle = .overFullScreen
            self.present(popupViewController, animated: false)
        case .deleteAccount:
            let withdrawalViewController = DeleteAccountVC()
            withdrawalViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(withdrawalViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageHeaderView.className) as? MyPageHeaderView else { return nil }
        if let getAccountData = self.getAccountData {
            view.dataBind(dataModel: getAccountData)
        }
        view.editButtonTappedClosure = {[weak self] in
            let editVC = EditMyProfileVC()
            editVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 104
    }
}

// MARK: - Network

extension MyPageVC {
    private func getAccountAPI() {
        MyPageAPI(viewController: self).getMyAccountInfo { response in
            if response?.success == true {
                if let accountData = response?.data {
                    self.getAccountData = accountData
                    self.myPageTableView.reloadData()
                }
            }
        }
    }
}
