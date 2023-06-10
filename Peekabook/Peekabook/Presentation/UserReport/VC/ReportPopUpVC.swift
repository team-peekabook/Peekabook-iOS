//
//  ReportPopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/25.
//

import UIKit

import SnapKit
import Then

import Moya

final class ReportPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    var friendId: Int = 0
    var reasonIndex: Int = 0
    var specificReason: String? = ""

    // MARK: - UI Components
    
    private lazy var reportPopUpVC = CustomPopUpView(frame: .zero, style: .report, viewController: self)

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension ReportPopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        reportPopUpVC.backgroundColor = .peekaBeige
        reportPopUpVC.getConfirmLabel(style: .report)
    }
    
    private func setLayout() {
        view.addSubview(reportPopUpVC)
        
        reportPopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension ReportPopUpVC {
    @objc func confirmButtonDidTap() {
        postUserReport(friendId: friendId, param: UserReportRequest(reasonIndex: reasonIndex, specificReason: specificReason))
    }
}

// MARK: - Network

extension ReportPopUpVC {
    private func postUserReport(friendId: Int, param: UserReportRequest) {
        FriendAPI(viewController: self).postUserReport(friendId: friendId, param: param) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
