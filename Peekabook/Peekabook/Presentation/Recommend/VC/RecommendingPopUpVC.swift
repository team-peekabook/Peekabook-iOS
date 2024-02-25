//
//  RecommendingPopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2/25/24.
//

import UIKit

import SnapKit
import Then

import Moya

final class RecommendingPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var recommendingPopUpView = CustomPopUpView(frame: .zero, style: .recommending, viewController: self)
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension RecommendingPopUpVC {
    
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        recommendingPopUpView.backgroundColor = .peekaBeige
        recommendingPopUpView.getConfirmLabel(style: .recommending)
    }
    
    private func setLayout() {
        view.addSubview(recommendingPopUpView)
        
        recommendingPopUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(156)
        }
    }
}

// MARK: - Methods

extension RecommendingPopUpVC {
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }

    @objc func confirmButtonDidTap() {
//        deleteBookAPI(id: bookShelfId)
    }
}

// MARK: - Network

//extension RecommendingPopUpVC {
//    
//    private func deleteBookAPI(id: Int) {
//        BookShelfAPI(viewController: self).deleteBook(bookId: id) { response in
//            if response?.success == true {
//                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
//            }
//        }
//    }
//}
