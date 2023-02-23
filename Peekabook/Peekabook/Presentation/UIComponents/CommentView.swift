//
//  CommentView.swift
//  Peekabook
//
//  Created by 고두영 on 2023/02/22.
//

import UIKit

class CommentView: UIView {

    // MARK: - UI Components
    
    let commentBoxView = UIView()
    private let commentHeaderView = UIView()
    
    private let commentLabel = UILabel().then {
        $0.text = I18N.BookDetail.comment
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    let commentTextView = UITextView().then {
        $0.text = I18N.BookDetail.commentHint
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.backgroundColor = .clear
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
        $0.returnKeyType = .done
    }
    
    let commentMaxLabel = UILabel().then {
        $0.text = I18N.BookAdd.length
        $0.font = .h2
        $0.textColor = .peekaGray2
    }
    
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

extension CommentView {
    
    private func setUI() {
        backgroundColor = .clear
        commentBoxView.backgroundColor = .peekaWhite_60
        commentBoxView.layer.borderWidth = 2
        commentBoxView.layer.borderColor = UIColor.peekaRed.cgColor
        commentHeaderView.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        
        addSubviews(commentBoxView, commentMaxLabel)
        
        [commentHeaderView, commentTextView].forEach {
            commentBoxView.addSubview($0)
        }
        
        [commentLabel].forEach {
            commentHeaderView.addSubview($0)
        }
        
        commentBoxView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(229)
        }
        
        commentHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(36)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(commentHeaderView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(commentBoxView).inset(14)
        }
        
        commentMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(commentBoxView.snp.bottom).offset(8)
            make.trailing.equalTo(commentBoxView.snp.trailing)
        }
    }
}
