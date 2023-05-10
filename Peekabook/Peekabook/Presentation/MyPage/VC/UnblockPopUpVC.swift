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
    func didPressUnblockedPopUp(_ userId: Int)
}

final class UnblockPopUpVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: UnblockablePopUp?
    var selectedUserId: Int
    
    // MARK: - UI Components
    
    private lazy var unblockPopUpView = CustomPopUpView(frame: .zero, style: .unblock, viewController: self)
    
    // MARK: - Initialization
    
    init(selectedUserId: Int) {
        self.selectedUserId = selectedUserId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    private func setLayout() {
        view.addSubview(unblockPopUpView)
        
        unblockPopUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(295)
            $0.height.equalTo(156)
        }
    }
}

// MARK: - @objc Function

extension UnblockPopUpVC {
    
    @objc
    func cancelButtonDidTap() {
        print("취소")
        self.dismiss(animated: false, completion: nil)
    }

    @objc
    func confirmButtonDidTap() {
        print("확인")
        delegate?.didPressUnblockedPopUp(selectedUserId)
    }
}

// MARK: - Methods

extension UnblockPopUpVC {
    
    func setData(nickName: String) {
        unblockPopUpView.getConfirmLabel(style: .unblock, personName: nickName)
    }
}
