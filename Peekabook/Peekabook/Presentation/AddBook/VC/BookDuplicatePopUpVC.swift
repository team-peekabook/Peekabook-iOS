//
//  BookDuplicatePopUpVC.swift
//  Peekabook
//
//  Created by 고두영 on 3/3/24.
//

import UIKit

import SnapKit
import Then

import Moya

final class BookDuplicatePopUpVC: UIViewController {
    
    // MARK: - Properties
    
    var publisher: String = ""
    
    // MARK: - UI Components
    
    private lazy var bookDuplicatePopUpview = CustomPopUpView(frame: .zero, style: .bookDuplicate, viewController: self)
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension BookDuplicatePopUpVC {
    
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        bookDuplicatePopUpview.getConfirmLabel(style: .bookDuplicate)
    }
    
    private func setLayout() {
        view.addSubview(bookDuplicatePopUpview)
        
        bookDuplicatePopUpview.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(136)
        }
    }
}

// MARK: - Methods

extension BookDuplicatePopUpVC {
    
    @objc func cancelButtonDidTap() {
//        self.dismiss(animated: false, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @objc func confirmButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
}
