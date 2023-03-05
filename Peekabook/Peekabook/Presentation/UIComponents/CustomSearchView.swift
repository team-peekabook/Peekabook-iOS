//
//  SearchView.swift
//  Peekabook
//
//  Created by 고두영 on 2023/02/24.
//

import UIKit

final class CustomSearchView: UIView {

    // MARK: - UI Components
    
    let searchContainerView = UIView()
    lazy var searchButton = UIButton()
    
    let searchTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: I18N.BookSearch.bookSearch,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.peekaGray1])
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.addLeftPadding()
        $0.autocorrectionType = .no
        $0.becomeFirstResponder()
        $0.returnKeyType = .done
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CustomSearchView: UITextFieldDelegate {
    
    private func setDelegate() {
        searchTextField.delegate = self
    }
    
    private func setUI() {
        backgroundColor = .clear
        
        searchContainerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        searchTextField.backgroundColor = .white.withAlphaComponent(0.4)
        searchButton.backgroundColor = .white.withAlphaComponent(0.4)
        searchButton.setImage(ImageLiterals.Icn.search, for: .normal)
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
