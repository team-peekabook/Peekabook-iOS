//
//  CustomTextView.swift
//  Peekabook
//
//  Created by 고두영 on 2023/02/22.
//

import UIKit

enum CustomTextViewType {
    case addBookMemo
    case addBookComment
    case editBookMemo
    case bookDetailComment
    case bookDetailMemo
}

final class CustomTextView: UIView {

    // MARK: - UI Components
    
    private let placeholderBlank: String = "          "
    
    private let boxView = UIView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    
    private let headerView = UIView()
    
    private let label = UILabel().then {
        $0.text = I18N.BookDetail.comment
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    
    private let textView = UITextView().then {
        $0.text = I18N.BookDetail.commentPlaceholder
        $0.font = .h2
        $0.textColor = .peekaGray1
        $0.autocorrectionType = .no
        $0.textContainerInset = .init(top: 0, left: -5, bottom: 0, right: 0)
        $0.returnKeyType = .done
    }
    
    private let maxLabel = UILabel().then {
        $0.text = I18N.BookAdd.commentLength
        $0.font = .h2
        $0.textColor = .peekaGray2
    }
    
    // MARK: - Initialization
    
    override var intrinsicContentSize: CGSize {
        return boxView.intrinsicContentSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundColor()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CustomTextView {
    
    private func setDelegate() {
        textView.delegate = self
    }
    
    private func setBackgroundColor() {
        backgroundColor = .clear
        
        boxView.backgroundColor = .clear
        textView.backgroundColor = .clear
        headerView.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        
        addSubviews(boxView, maxLabel)
        
        [headerView, textView].forEach {
            boxView.addSubview($0)
        }
        
        headerView.addSubview(label)
        
        boxView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(14)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(boxView).inset(14)
        }
        
        maxLabel.snp.makeConstraints {
            $0.top.equalTo(boxView.snp.bottom).offset(8)
            $0.trailing.equalTo(boxView.snp.trailing)
        }
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == I18N.BookDetail.commentPlaceholder + placeholderBlank) ||
            (textView.text == I18N.BookDetail.memoPlaceholder) ||
            (textView.text == I18N.BookDetail.emptyComment) ||
            (textView.text == I18N.BookDetail.emptyMemo) {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if label.text == I18N.BookDetail.comment {
                textView.text = I18N.BookDetail.commentPlaceholder
                textView.textColor = .peekaGray1
            } else {
                textView.text = I18N.BookDetail.memoPlaceholder
                textView.textColor = .peekaGray1
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if label.text == I18N.BookDetail.comment {
            maxLabel.text = "\(textView.text.count)/200"
            if textView.text.count > 200 {
                textView.deleteBackward()
            }
        } else {
            maxLabel.text = "\(textView.text.count)/50"
            if textView.text.count > 50 {
                textView.deleteBackward()
            }
        }
    }
}

extension CustomTextView {
    func updateTextView(type: CustomTextViewType) {
        switch type {
        case .addBookMemo:
            boxView.frame.size.height = 101
            boxView.backgroundColor = .peekaWhite_60
            label.text = I18N.BookDetail.memo
            textView.text = I18N.BookDetail.memoPlaceholder
            maxLabel.text = I18N.BookAdd.memoLength
        case .addBookComment:
            boxView.backgroundColor = .peekaWhite_60
        case .editBookMemo:
            boxView.frame.size.height = 101
            label.text = I18N.BookDetail.memo
            textView.text = I18N.BookDetail.memoPlaceholder
        case .bookDetailComment:
            maxLabel.isHidden = true
            textView.isUserInteractionEnabled = false
        case .bookDetailMemo:
            label.text = I18N.BookDetail.memo
            maxLabel.isHidden = true
            boxView.frame.size.height = 101
            textView.isUserInteractionEnabled = false
        }
    }
        
        func getBoxView() -> UIView {
            return self.boxView
    }

    func getTextView() -> UITextView {
        return self.textView
    }
    
    func getMaxLabel() -> UILabel {
        return self.maxLabel
    }
}
