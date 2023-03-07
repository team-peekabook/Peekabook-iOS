//
//  DeletePopUpVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/12.
//

import UIKit

import SnapKit
import Then

import Moya

final class DeletePopUpVC: UIViewController {
    
    // MARK: - Properties

    var bookShelfId: Int = 0
    
    // MARK: - UI Components
    
    private var deletePopUpview: CustomPopUpView!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        deletePopUpview = CustomPopUpView(frame: .zero, style: .delete, viewController: self)
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout
extension DeletePopUpVC {
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    private func setLayout() {
        view.addSubview(deletePopUpview)
        
        deletePopUpview.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension DeletePopUpVC {
    
    @objc func touchCancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }

    @objc func touchConfirmButtonDidTap() {
        deleteBookAPI(id: bookShelfId)
    }
}

// MARK: - Network

extension DeletePopUpVC {
    private func deleteBookAPI(id: Int) {
        BookShelfAPI.shared.deleteBook(bookId: id) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
