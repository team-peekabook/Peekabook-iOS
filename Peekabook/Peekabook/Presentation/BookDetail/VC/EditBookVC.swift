//
//  EditBookVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/07.
//

import UIKit

import SnapKit
import Then

import Moya

final class EditBookVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    
    private let headerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var touchBackButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchBackButtonDidTap), for: .touchUpInside)
    }
    
    private let headerTitle = UILabel().then {
        $0.text = "책 수정하기"
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private let touchCheckButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel!.font = .h4
        $0.setTitleColor(.peekaRed, for: .normal)
        $0.addTarget(AddBookVC.self, action: #selector(touchCheckButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var containerView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    private let bookImgView = UIImageView()
    
    private var nameLabel = UILabel().then {
        $0.text = "아무튼, 여름"
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private var authorLabel = UILabel().then {
        $0.text = "김신회"
        $0.font = .h2
        $0.textColor = .peekaRed
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        config()
    }
}

// MARK: - UI & Layout
extension EditBookVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        [containerView, headerView].forEach {
            view.addSubview($0)
        }
        
        [touchBackButton, headerTitle, touchCheckButton].forEach {
            headerView.addSubview($0)
        }
        
        [bookImgView, nameLabel, authorLabel].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        touchBackButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        headerTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        touchCheckButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(11)
            make.width.height.equalTo(48)
        }
        
        bookImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(bookImgView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension EditBookVC {
    // TODO: - 바코드 스캔뷰로 다시 가게 해야함
    // 현재는 홈뷰로 가는 상황
    @objc private func touchBackButtonDidTap() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // TODO: - push 함수 작성 필요
    @objc private func touchCheckButtonDidTap() {
        // doSomething()
    }
    
    private func config() {
        touchBackButton.setImage(ImageLiterals.Icn.back, for: .normal)
        
        bookImgView.image = ImageLiterals.Sample.book1
    }
}
