//
//  DoubleHeaderLineView.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/05.
//

import UIKit

final class DoubleHeaderLineView: UIView {
    
    // MARK: - UI Components
    
    private let boldLine = UIView()
    private let thinLine = UIView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension DoubleHeaderLineView {
    
    private func setUI() {
        backgroundColor = .clear
        boldLine.backgroundColor = .peekaRed
        thinLine.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        
        addSubviews(boldLine, thinLine)
        
        boldLine.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        thinLine.snp.makeConstraints {
            $0.top.equalTo(boldLine.snp.bottom).offset(1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
