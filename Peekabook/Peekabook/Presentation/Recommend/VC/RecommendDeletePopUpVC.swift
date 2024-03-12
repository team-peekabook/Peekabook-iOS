//
//  RecommendDeletePopUpVC.swift
//  Peekabook
//
//  Created by 김인영 on 2024/03/12.
//

import UIKit

import SnapKit
import Then

import Moya

final class RecommendDeletePopUpVC: UIViewController {
    
    // MARK: - Properties
    
    var recommendId: Int = 0

    // MARK: - UI Components
    
    private lazy var deletePopUpVC = CustomPopUpView(frame: .zero, style: .deleteRecommend, viewController: self)

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension RecommendDeletePopUpVC {

    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        deletePopUpVC.backgroundColor = .peekaBeige
        deletePopUpVC.getConfirmLabel(style: .deleteRecommend, personName: "선택한 ", detailComment: I18N.BookRecommend.deleteRecommendDetailComment)
    }
    
    private func setLayout() {
        view.addSubview(deletePopUpVC)
        
        deletePopUpVC.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(156)
        }
    }
}

// MARK: - Methods

extension RecommendDeletePopUpVC {
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func confirmButtonDidTap() {
        deleteRecommendedAPI(recommendId: recommendId)
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - Network

extension RecommendDeletePopUpVC {
    private func deleteRecommendedAPI(recommendId: Int) {
        RecommendAPI(viewController: self).deleteRecommend(recommendId: recommendId) { response in
            if response?.success == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RecommendDeletedNotification"), object: nil, userInfo: ["recommendID": recommendId])
            }
        }
    }
}
