//
//  DoubleBottomLineView.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/05.
//

import UIKit

final class DoubleBottomLineView: UIView {
    
    // MARK: - UI Components
    
    private let thinLine = UIView()
    private let boldLine = UIView()
    
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

extension DoubleBottomLineView {
    
    private func setUI() {
        backgroundColor = .clear
        thinLine.backgroundColor = .peekaRed
        boldLine.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        
        addSubviews(boldLine, thinLine)
        
        boldLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        thinLine.snp.makeConstraints {
            $0.bottom.equalTo(boldLine.snp.top).offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
