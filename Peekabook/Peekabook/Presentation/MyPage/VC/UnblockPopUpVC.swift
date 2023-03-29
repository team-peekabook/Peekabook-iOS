//
//  UnblockPopUpVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/29.
//

import UIKit

import SnapKit

// MARK: - Protocols

protocol UnblockablePopUp: Unblockable {
    func didPressUnblockedPopUp(index: Int)
}

final class UnblockPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: UnblockablePopUp?
    var selectedUserIndex: Int?
    
    // MARK: - UI Components
    
    private lazy var unblockPopUpview = CustomPopUpView(frame: .zero, style: .unblock, viewController: self)
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
    }
}

// MARK: - UI & Layout

extension UnblockPopUpVC {
    
    private func setUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        unblockPopUpview.getConfirmLabel(style: .unblock, personName: String(selectedUserIndex ?? -1)) // personName은 임시로 넣었습니다.
    }
    
    private func setLayout() {
        view.addSubview(unblockPopUpview)
        
        unblockPopUpview.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(120)
        }
    }
}

// MARK: - @objc Function

extension UnblockPopUpVC {
    
    @objc
    func cancelButtonDidTap() {
        self.dismiss(animated: false, completion: nil)
    }

    @objc
    func confirmButtonDidTap() {
        guard let selectedUserIndex else { return }
        delegate?.didPressUnblockedPopUp(index: selectedUserIndex)
    }
}
