//
//  CustomTextView.swift
//  Peekabook
//
//  Created by 고두영 on 2023/02/22.
//

import UIKit

enum CustomTextViewType: CaseIterable {
    case addBookMemo
    case addBookComment
    case editBookMemo
    case editBookComment
    case bookDetailComment
    case bookDetailMemo
    case bookProposal
    case editProfileIntro
    case addProfileIntro
}

protocol IntroText: AnyObject {
    func getTextView(text: String)
}

final class CustomTextView: UIView {
    
    // MARK: - UI Components
    
    private let placeholderBlank: String = "          "
    
    var text: String? {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
        }
    }
    
    weak var delegate: IntroText?
    
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
    
    private lazy var textView = UITextView().then {
        $0.text = I18N.BookDetail.commentPlaceholder + placeholderBlank
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
    
    private let lineView = UIView().then {
        $0.backgroundColor = .peekaWhite
    }
        
    let personNameLabel = UILabel().then {
        $0.font = .s3
        $0.textColor = .peekaWhite
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
        
        [label, lineView, personNameLabel].forEach {
            headerView.addSubview($0)
        }
        
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
        
        lineView.snp.makeConstraints {
            $0.centerY.equalTo(label)
            $0.leading.equalTo(label.snp.trailing).offset(8)
            $0.width.equalTo(1)
            $0.height.equalTo(12)
        }

        personNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(label)
            $0.leading.equalTo(lineView.snp.trailing).offset(8)
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

extension CustomTextView {
    func updateTextView(type: CustomTextViewType) {
        switch type {
        case .addBookMemo:
            boxView.frame.size.height = 101
            boxView.backgroundColor = .peekaWhite_60
            label.text = I18N.BookDetail.memo
            textView.text = I18N.BookDetail.memoPlaceholder + placeholderBlank
            maxLabel.text = I18N.BookAdd.memoLength
            proposalItemhidden()
        case .addBookComment:
            boxView.backgroundColor = .peekaWhite_60
            textView.text = I18N.BookDetail.commentPlaceholder + placeholderBlank
            proposalItemhidden()
        case .editBookMemo:
            boxView.frame.size.height = 101
            label.text = I18N.BookDetail.memo
            textView.text = I18N.BookDetail.memoPlaceholder + placeholderBlank
            proposalItemhidden()
        case .editBookComment:
            proposalItemhidden()
        case .bookDetailComment:
            maxLabel.isHidden = true
            textView.isUserInteractionEnabled = false
            proposalItemhidden()
        case .bookDetailMemo:
            label.text = I18N.BookDetail.memo
            maxLabel.isHidden = true
            boxView.frame.size.height = 101
            textView.isUserInteractionEnabled = false
            proposalItemhidden()
        case .bookProposal:
            textView.text = I18N.PlaceHolder.recommend
            label.text = I18N.BookProposal.personName
            boxView.backgroundColor = .peekaWhite_60
        case .editProfileIntro:
            label.text = I18N.Profile.oneLineIntro
            textView.text = UserDefaults.standard.string(forKey: "userIntro")
            maxLabel.text = "\(textView.text.count)/40"
            textView.textColor = .peekaRed
            proposalItemhidden()
        case .addProfileIntro:
            label.text = I18N.Profile.oneLineIntro
            textView.text = I18N.PlaceHolder.profileIntro + placeholderBlank
            maxLabel.text = "\(textView.text.count)/40"
            textView.textColor = .peekaRed
            proposalItemhidden()
        }
    }
    
    func proposalItemhidden() {
        lineView.isHidden = true
        personNameLabel.isHidden = true
    }
    
    func setTextColor(_ color: UIColor) {
        textView.textColor = color
    }
    
    func setTextCustomMaxLabel(_ text: String) {
        maxLabel.text = text
    }
    
    func isTextViewFirstResponder() -> Bool {
        return textView.isFirstResponder
    }
    
    func getPositionForKeyboard(keyboardFrame: CGRect) -> CGPoint {
        let textViewHeight = boxView.frame.height
        return CGPoint(x: 0, y: boxView.frame.origin.y - keyboardFrame.size.height + textViewHeight + 250)
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == I18N.BookDetail.commentPlaceholder + placeholderBlank) ||
            (textView.text == I18N.BookDetail.memoPlaceholder + placeholderBlank) ||
            (textView.text == I18N.BookDetail.emptyComment) ||
            (textView.text == I18N.BookDetail.emptyMemo) ||
            (textView.text == I18N.PlaceHolder.recommend) ||
            (textView.text == I18N.PlaceHolder.profileIntro + placeholderBlank) ||
            (textView.text == I18N.PlaceHolder.nickname + placeholderBlank) {
            textView.text = nil
            textView.textColor = .peekaRed
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if label.text == I18N.BookDetail.comment {
                textView.text = I18N.BookDetail.commentPlaceholder + placeholderBlank
                textView.textColor = .peekaGray1
            } else if label.text == I18N.BookProposal.personName {
                textView.text = I18N.PlaceHolder.recommend
                textView.textColor = .peekaGray1
            } else if label.text == I18N.BookDetail.memo {
                textView.text = I18N.BookDetail.memoPlaceholder + placeholderBlank
                textView.textColor = .peekaGray1
            } else if label.text == I18N.Profile.oneLineIntro {
                textView.text = I18N.PlaceHolder.profileIntro + placeholderBlank
                textView.textColor = .peekaGray1
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        delegate?.getTextView(text: textView.text)
        
        if label.text == I18N.BookDetail.comment || label.text == I18N.BookProposal.personName {
            maxLabel.text = "\(textView.text.count)/200"
            if textView.text.count > 200 {
                textView.deleteBackward()
            }
        } else if label.text == I18N.Profile.oneLineIntro {
            if textView.text.count > 40 {
                textView.deleteBackward()
            } else {
                maxLabel.text = "\(textView.text.count)/40"
            }
        } else {
            if textView.text.count > 50 {
                textView.deleteBackward()
            }
        }
    }
}
