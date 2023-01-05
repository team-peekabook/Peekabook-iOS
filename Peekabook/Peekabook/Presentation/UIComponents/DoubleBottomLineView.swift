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
        
        boldLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        thinLine.snp.makeConstraints { make in
            make.bottom.equalTo(boldLine.snp.top).offset(-1)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
