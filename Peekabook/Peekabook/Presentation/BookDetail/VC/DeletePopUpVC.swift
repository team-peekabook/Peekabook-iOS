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
    
    private let popUpView = CustomPopUpView()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addTargets()
    }
}

// MARK: - UI & Layout
extension DeletePopUpVC {
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        popUpView.confirmButton.setTitle(I18N.Confirm.delete, for: .normal)
    }
    
    private func setLayout() {
        view.addSubview(popUpView)
        
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension DeletePopUpVC {
    
    private func addTargets() {
        popUpView.cancelButton.addTarget(self, action: #selector(touchCancelButtonDidTap), for: .touchUpInside)
        popUpView.confirmButton.addTarget(self, action: #selector(touchConfirmButtonDipTap), for: .touchUpInside)
    }
    
    @objc private func touchCancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }

    @objc private func touchConfirmButtonDipTap() {
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
