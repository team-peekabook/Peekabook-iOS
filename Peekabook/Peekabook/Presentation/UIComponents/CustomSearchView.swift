//
//  SearchView.swift
//  Peekabook
//
//  Created by 고두영 on 2023/02/24.
//

import UIKit

enum CustomSearchType: CaseIterable {
    case userSearch
    case bookSearch
}

final class CustomSearchView: UIView {
    
    // MARK: - UI Components
    
    private let searchContainerView = UIView()
    private lazy var searchButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.search, for: .normal)
    }
    
    private let searchTextField = UITextField().then {
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.addLeftPadding()
        $0.autocorrectionType = .no
//        $0.becomeFirstResponder()
        $0.returnKeyType = .done
    }
    
    // MARK: - Initialization
    
    init(frame: CGRect, type: CustomSearchType, viewController: UIViewController) {
        super.init(frame: frame)
        setBackgroundColor()
        setLayout()
        setCustomSearchView(type: type, viewController: viewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showKeyboard() {
        searchTextField.becomeFirstResponder()
    }
}

// MARK: - Methods

extension CustomSearchView: UITextFieldDelegate {
    
    private func setBackgroundColor() {
        backgroundColor = .clear
        
        searchContainerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        searchTextField.backgroundColor = .white.withAlphaComponent(0.4)
        searchButton.backgroundColor = .white.withAlphaComponent(0.4)
    }
    
    private func setLayout() {
        
        addSubview(searchContainerView)
        
        [searchButton, searchTextField].forEach {
            searchContainerView.addSubview($0)
        }
        
        searchContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.top.leading.equalToSuperview()
            $0.trailing.equalTo(searchButton.snp.leading)
            $0.height.equalTo(40)
        }
    }
}

extension CustomSearchView {
    
    func setCustomSearchView(type: CustomSearchType, viewController: UIViewController) {
        switch type {
        case .userSearch:
            searchButton.addTarget(viewController, action: #selector(UserSearchVC.searchBtnTapped), for: .touchUpInside)
            searchTextField.placeholder = I18N.PlaceHolder.userSearch
        case .bookSearch:
            searchButton.addTarget(viewController, action: #selector(BookSearchVC.searchButtonDidTap), for: .touchUpInside)
            searchTextField.placeholder = I18N.PlaceHolder.bookSearch
        }
    }
    
    var text: String? {
        return searchTextField.text
    }
    
    func hasSearchText() -> Bool {
        return searchTextField.hasText
    }
    
    func setSearchTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        searchTextField.delegate = delegate
    }
    
    func endEditing() {
        searchTextField.endEditing(true)
    }
}
