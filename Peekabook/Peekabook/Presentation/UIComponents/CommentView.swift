//
//  CommentView.swift
//  Peekabook
//
//  Created by 고두영 on 2023/02/22.
//

import UIKit

class CommentView: UIView {

    // MARK: - UI Components
    
    let commentBoxView = UIView(frame: CGRect(x: 0, y: 0, width: 335, height: 229))
    private let commentHeaderView = UIView()
    
    let commentLabel = UILabel().then {
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
        $0.text = I18N.BookAdd.commentLength
        $0.font = .h2
        $0.textColor = .peekaGray2
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Methods

extension CommentView {
    
    private func setDelegate() {
        commentTextView.delegate = self
    }
    
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
        
        commentHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        commentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
        }
        
        commentTextView.snp.makeConstraints {
            $0.top.equalTo(commentHeaderView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(commentBoxView).inset(14)
        }
        
        commentMaxLabel.snp.makeConstraints {
            $0.top.equalTo(commentBoxView.snp.bottom).offset(8)
            $0.trailing.equalTo(commentBoxView.snp.trailing)
        }
    }
}

extension CommentView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == I18N.BookDetail.commentHint) || (textView.text == I18N.BookDetail.memoHint) ||  (textView.text == I18N.BookDetail.emptyComment) || (textView.text == I18N.BookDetail.emptyMemo) {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if commentLabel.text == I18N.BookDetail.comment {
                commentTextView.text = I18N.BookDetail.commentHint
                commentTextView.textColor = .peekaGray1
            } else {
                commentTextView.text = I18N.BookDetail.memoHint
                commentTextView.textColor = .peekaGray1
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if commentLabel.text == I18N.BookDetail.comment {
            commentMaxLabel.text = "\(commentTextView.text.count)/200"
            if commentTextView.text.count > 200 {
                commentTextView.deleteBackward()
            }
        } else {
            commentMaxLabel.text = "\(commentTextView.text.count)/50"
            if commentTextView.text.count > 50 {
                commentTextView.deleteBackward()
            }
        }
    }
}
