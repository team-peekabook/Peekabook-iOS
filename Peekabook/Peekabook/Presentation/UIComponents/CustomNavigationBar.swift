//
//  CustomNavigationBar.swift
//  Peekabook
//
//  Created by devxsby on 2023/03/07.
//

import UIKit

@frozen
enum NaviType {
    case oneLeftButton
    case oneRightButton
    case oneLeftButtonWithOneRightButton
    case oneLeftButtonWithTwoRightButtons
}

final class CustomNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var vc: UIViewController?
    private var rightButtonClosure: (() -> Void)?
    private var otherRightButtonClosure: (() -> Void)?
    private var leftButtonClosure: (() -> Void)?
    
    var isProfileEditComplete: Bool = true {
        didSet {
            if isProfileEditComplete {
                self.rightButton.setTitleColor(.peekaRed, for: .normal)
                self.rightButton.isEnabled = true
            } else {
                self.rightButton.setTitleColor(.peekaGray1, for: .normal)
                self.rightButton.isEnabled = false
            }
        }
    }
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let leftButton = SingleTouchButton(type: .system)
    private let rightButton = SingleTouchButton(type: .system)
    private let otherRightButton = SingleTouchButton(type: .system)
    private let underlineView = UIView()
    
    // MARK: - initialization
    
    init(_ vc: UIViewController, type: NaviType, backgroundColor: UIColor = .peekaBeige) {
        super.init(frame: .zero)
        self.vc = vc
        self.setUI(type, backgroundColor: backgroundColor)
        self.setLayout(type)
        self.setLeftBackButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension CustomNavigationBar {
    
    private func setLeftBackButtonAction() {
        self.leftButton.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
    }
    
    @discardableResult
    func addMiddleLabel(title: String?) -> Self {
        self.titleLabel.text = title
        self.titleLabel.font = .h3
        self.titleLabel.textColor = .peekaRed
        return self
    }
    
    @discardableResult
    func addRightButton(with title: String?) -> Self {
        self.rightButton.setTitle(title, for: .normal)
        self.rightButton.titleLabel?.font = .h4
        self.rightButton.setTitleColor(.peekaRed, for: .normal)
        self.rightButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().inset(20)
        }
        return self
    }
    
    @discardableResult
    func addRightButton(with image: UIImage?) -> Self {
        self.rightButton.setImage(image, for: .normal)
        return self
    }
    
    @discardableResult
    func addOtherRightButton(with image: UIImage?) -> Self {
        self.otherRightButton.setImage(image, for: .normal)
        return self
    }
    
    @discardableResult
    func changeLeftBackButtonToLogoImage() -> Self {
        self.leftButton.isUserInteractionEnabled = false
        self.leftButton.setImage(ImageLiterals.Image.logo!, for: .normal)
        self.leftButton.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(20)
        }
        return self
    }
    
    @discardableResult
    func changeLeftBackButtonToXmark() -> Self {
        self.leftButton.setImage(ImageLiterals.Icn.close, for: .normal)
        return self
    }
    
    @discardableResult
    func addRightButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.rightButtonClosure = closure
        self.rightButton.addTarget(self, action: #selector(touchupRightButton), for: .touchUpInside)
        return self
    }
    
    @discardableResult
    func addOtherRightButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.otherRightButtonClosure = closure
        self.otherRightButton.addTarget(self, action: #selector(touchupOtherRightButton), for: .touchUpInside)
        return self
    }
    
    @discardableResult
    func addUnderlineView() -> Self {
        self.underlineView.backgroundColor = .peekaRed
        setUnderlineLayout()
        return self
    }
    
    @discardableResult
    func addLeftButtonAction(_ closure: (() -> Void)? = nil) -> Self {
        self.leftButtonClosure = closure
        self.leftButton.addTarget(self, action: #selector(touchupLeftButton), for: .touchUpInside)
        return self
    }
    
    func hideRightButtons() {
        self.rightButton.isHidden = true
        self.otherRightButton.isHidden = true
    }
}

// MARK: - @objc Function

extension CustomNavigationBar {
    
    @objc
    private func popToPreviousVC() {
        self.vc?.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func touchupRightButton() {
        self.rightButtonClosure?()
    }
    
    @objc
    private func touchupOtherRightButton() {
        self.otherRightButtonClosure?()
    }
    
    @objc
    private func touchupLeftButton() {
        self.leftButtonClosure?()
    }
    
    @objc func checkRightButton() {
        self.rightButtonClosure?()
    }
}

// MARK: - UI & Layout

extension CustomNavigationBar {
    
    private func setUI(_ type: NaviType, backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        
        switch type {
        case .oneLeftButton, .oneLeftButtonWithTwoRightButtons, .oneLeftButtonWithOneRightButton:
            leftButton.setImage(ImageLiterals.Icn.back, for: .normal)
        case .oneRightButton:
            rightButton.setImage(ImageLiterals.Icn.close, for: .normal)
        }
    }
    
    private func setLayout(_ type: NaviType) {
        self.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        switch type {
        case .oneLeftButton:
            self.setOneLeftButtonLayout()
        case .oneRightButton:
            self.setOneRightButtonLayout()
        case .oneLeftButtonWithOneRightButton:
            self.setOneLeftButtonWithOneRightButtonLayout()
        case .oneLeftButtonWithTwoRightButtons:
            self.setOneLeftButtonWithTwoRightButtonsLayout()
        }
    }
    
    private func setOneLeftButtonLayout() {
        self.addSubviews(titleLabel, leftButton)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }
    
    private func setOneRightButtonLayout() {
        self.addSubviews(titleLabel, rightButton)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
            $0.width.equalTo(48)
        }
    }
    
    private func setOneLeftButtonWithOneRightButtonLayout() {
        self.addSubviews(leftButton, rightButton, titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
    }
    
    private func setOneLeftButtonWithTwoRightButtonsLayout() {
        self.addSubviews(titleLabel, leftButton, rightButton, otherRightButton)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.centerY.leading.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
        
        otherRightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(rightButton.snp.leading)
        }
    }
    
    private func setUnderlineLayout() {
        self.addSubviews(underlineView)
        
        underlineView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(2)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(2)
        }
    }
}
