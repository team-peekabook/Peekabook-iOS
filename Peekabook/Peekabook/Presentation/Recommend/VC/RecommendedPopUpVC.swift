//
//  RecommendedPopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 2/26/24.
//

import UIKit

import SnapKit
import Then

import Moya

final class RecommendedPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private lazy var recommendedPopUpView = CustomPopUpView(frame: .zero, style: .recommended, viewController: self)
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension RecommendedPopUpVC {
    
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        recommendedPopUpView.backgroundColor = .peekaBeige
        recommendedPopUpView.getConfirmLabel(style: .recommended)
    }
    
    private func setLayout() {
        view.addSubview(recommendedPopUpView)
        
        recommendedPopUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(156)
        }
    }
}

// MARK: - Methods

extension RecommendedPopUpVC {
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }

    @objc func confirmButtonDidTap() {
//        deleteBookAPI(id: bookShelfId)
    }
}

// MARK: - Network

//extension RecommendedPopUpVC {
//
//    private func deleteBookAPI(id: Int) {
//        BookShelfAPI(viewController: self).deleteBook(bookId: id) { response in
//            if response?.success == true {
//                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
//            }
//        }
//    }
//}
