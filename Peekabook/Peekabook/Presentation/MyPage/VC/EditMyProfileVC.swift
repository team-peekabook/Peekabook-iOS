//
//  EditMyProfileVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/03/23.
//

import UIKit

import SnapKit
import Then

import Moya

final class EditMyProfileVC: UIViewController {
    
    // MARK: - Properties
    
    var nicknameText: String = UserDefaultKeyList.userNickname ?? ""
    var introText: String = UserDefaultKeyList.userIntro ?? ""
    var userImage: String = UserDefaultKeyList.userProfileImage ?? ""
    private var temporaryName: String = UserDefaultKeyList.userNickname ?? ""
    
    var isImageDefaultType: Bool = true {
        didSet {
            if isImageDefaultType {
                self.isImageDefaultType = true
                self.profileImageView.image = ImageLiterals.Icn.emptyProfileImage
                self.editImageButton.setImage(ImageLiterals.Icn.addProfileImage, for: .normal)
            } else {
                self.isImageDefaultType = false
                self.editImageButton.setImage(ImageLiterals.Icn.profileImageEdit, for: .normal)
            }
        }
    }
    
    var isDoubleChecked: Bool = true {
        didSet {
            if isDoubleChecked {
                doubleCheckErrorLabel.isHidden = true
                doubleCheckSuccessLabel.isHidden = false
                doubleCheckButton.backgroundColor = .peekaGray1
                doubleCheckButton.isEnabled = false
            } else {
                doubleCheckButton.backgroundColor = .peekaRed
                doubleCheckButton.isEnabled = true
                self.doubleCheckErrorLabel.isHidden = false
                self.doubleCheckSuccessLabel.isHidden = true
            }
            
            checkComplete()
        }
    }
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton)
        .addMiddleLabel(title: I18N.Profile.editmyPage)
        .addRightButton(with: I18N.BookProposal.done)
        .addRightButtonAction {
            self.checkButtonDidTap()
        }
    
    private let containerScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let profileImageContainerView = UIView()
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 40
    }
    private lazy var editImageButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.profileImageEdit, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(imagePickDidTap), for: .touchUpInside)
    }
    
    private let nicknameContainerView = UIView().then {
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.peekaRed.cgColor
    }
    
    private let nicknameHeaderView = UIView()
    private let nicknameLabel = UILabel().then {
        $0.text = I18N.Profile.nickname
        $0.font = .h1
        $0.textColor = .peekaWhite
    }
    private let nicknameTextContainerView = UIView()
    private lazy var nicknameTextField = UITextField().then {
        $0.textColor = .peekaRed
        $0.addLeftPadding()
        $0.autocorrectionType = .no
        $0.returnKeyType = .done
        $0.font = .h2
        $0.text = UserDefaultKeyList.userNickname
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        $0.delegate = self
    }
    private lazy var doubleCheckButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Profile.doubleCheck, for: .normal)
        $0.backgroundColor = .peekaGray1
        $0.setTitleColor(.peekaWhite, for: .normal)
        $0.titleLabel?.font = .c1
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(doubleCheckButtonDidTap), for: .touchUpInside)
    }
    private let doubleCheckErrorLabel = UILabel().then {
        $0.text = I18N.Profile.doubleCheckError
        $0.font = .s3
        $0.textColor = .peekaRed
        $0.isHidden = true
    }
    private let doubleCheckSuccessLabel = UILabel().then {
        $0.text = I18N.Profile.doubleCheckSuccess
        $0.font = .s3
        $0.textColor = .peekaRed
        $0.isHidden = true
    }
    private let countMaxTextLabel = UILabel().then {
        if let name = UserDefaultKeyList.userNickname {
            $0.text = "\(name.count)" + I18N.Profile.nicknameLength
            $0.font = .h2
            $0.textColor = .peekaGray2
        }
    }
    
    private let introContainerView = CustomTextView()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setLayout()
        setTapGesture()
        setIntroView()
        addKeyboardObserver()
        getAccountAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIsDefaultImage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UI & Layout

extension EditMyProfileVC {
    
    private func setBackgroundColor() {
        view.backgroundColor = .peekaBeige
        nicknameHeaderView.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, containerScrollView)
        containerScrollView.addSubviews(profileImageContainerView, nicknameContainerView, introContainerView)
        profileImageContainerView.addSubviews(profileImageView, editImageButton)
        nicknameContainerView.addSubviews(nicknameHeaderView, nicknameTextContainerView, doubleCheckErrorLabel, doubleCheckSuccessLabel, countMaxTextLabel)
        nicknameHeaderView.addSubviews(nicknameLabel)
        nicknameTextContainerView.addSubviews(nicknameTextField, doubleCheckButton)
    
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        containerScrollView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(82)
            $0.height.equalTo(100)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(80)
        }
        
        editImageButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.height.width.equalTo(24)
        }
        
        nicknameContainerView.snp.makeConstraints {
            $0.top.equalTo(profileImageContainerView.snp.bottom).offset(54)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(79)
        }
        
        nicknameHeaderView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.centerY.equalToSuperview()
        }
        
        nicknameTextContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        doubleCheckButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(26)
            $0.width.equalTo(53)
        }
        
        doubleCheckErrorLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameContainerView.snp.bottom).offset(10)
            $0.leading.equalTo(nicknameContainerView)
        }
        
        doubleCheckSuccessLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameContainerView.snp.bottom).offset(10)
            $0.leading.equalTo(nicknameContainerView)
        }
        
        countMaxTextLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameContainerView.snp.bottom).offset(8)
            $0.trailing.equalTo(nicknameContainerView)
        }
        
        introContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameContainerView.snp.bottom).offset(48)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalToSuperview().inset(11)
            $0.height.equalTo(101)
        }
    }
}

// MARK: - Methods

extension EditMyProfileVC {
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let nicknameText = textField.text else { return }
        
        self.nicknameText = nicknameText
        
        // 기존 닉네임 값과 동일하거나 빈 경우 -> 중복확인 불가
        if nicknameText.isEmpty || temporaryName == nicknameText {
            doubleCheckButton.backgroundColor = .peekaGray1
            self.isDoubleChecked = true
        } else {
            self.isDoubleChecked = false
        }
        
        if nicknameText.count > 6 {
            textField.deleteBackward()
        } else {
            countMaxTextLabel.text = "\(nicknameText.count)\(I18N.Profile.nicknameLength)"
        }
        doubleCheckErrorLabel.isHidden = true
        doubleCheckSuccessLabel.isHidden = true
        
        self.checkComplete()
    }
    
    @objc private func doubleCheckButtonDidTap() {
        let isDuplicated = CheckDuplicateRequest(nickname: nicknameText)
        checkDuplicateComplete(param: isDuplicated) { [weak self] isDoubleChecked in
            guard let self = self else { return }
            
            // 기존의 UserNickname과 같은 경우
            if self.nicknameText == UserDefaultKeyList.userNickname {
                self.temporaryName = self.nicknameText
                self.isDoubleChecked = true
                self.doubleCheckButton.backgroundColor = .peekaGray1
            }
            
            // 닉네임이 중복확인 -> 참인 경우
            if isDoubleChecked {
                self.temporaryName = self.nicknameText
                self.doubleCheckButton.backgroundColor = .peekaGray1
                self.doubleCheckErrorLabel.isHidden = true
                self.doubleCheckSuccessLabel.isHidden = false
            }
            
            self.checkComplete()
            
            print("isDoubleChecked? ", isDoubleChecked)
            print("self.introText? ", self.nicknameText)
            print("임시 저장된 이름은 ", self.temporaryName)
        }
    }
    
    @objc private func checkButtonDidTap() {
        guard let profileImage = profileImageView.image else { return }

        editMyProfile(request: PatchProfileRequest(nickname: nicknameText, intro: introText), image: profileImage)
    }
    
    private func setIntroView() {
        introContainerView.updateTextView(type: .editProfileIntro)
        introContainerView.delegate = self
    }
    
    private func setTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePickDidTap))
        profileImageContainerView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func checkIsDefaultImage() {
        if profileImageView.image == ImageLiterals.Icn.emptyProfileImage || userImage.isEmpty == true {
            self.isImageDefaultType = true
        } else {
            self.isImageDefaultType = false
        }
    }
    
    private func checkComplete() {
        if !self.nicknameText.isEmpty && !self.introText.isEmpty && self.isDoubleChecked {
            naviBar.isProfileEditComplete = true
        } else {
            naviBar.isProfileEditComplete = false
        }
    }
    
    @objc private func imagePickDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (action) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "앨범", style: .default, handler: { (action) in
            self.openPhotoLibrary()
        }))
        
        if !isImageDefaultType {
            alert.addAction(UIAlertAction(title: "기본이미지로 변경", style: .default, handler: { (action) in
                self.isImageDefaultType = true
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height + 20,
            right: 0.0)
        
        containerScrollView.contentInset = contentInset
        containerScrollView.scrollIndicatorInsets = contentInset
        
        if nicknameTextField.isFirstResponder || introContainerView.isTextViewFirstResponder() {
            var position = introContainerView.getPositionForKeyboard(keyboardFrame: keyboardFrame)
            containerScrollView.setContentOffset(position, animated: true)
        }
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        containerScrollView.contentInset = contentInset
        containerScrollView.scrollIndicatorInsets = contentInset
        UIView.animate(withDuration: 0.2, animations: {
            self.containerScrollView.transform = .identity
        })
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditMyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profileImageView.image = fixOrientation(img: image)
            self.isImageDefaultType = false
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 세로 이미지 회전 문제로 인한 함수
    private func fixOrientation(img: UIImage) -> UIImage {
        if img.imageOrientation == .up {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}

// MARK: - UITextFieldDelegate

extension EditMyProfileVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let utf8Char = string.cString(using: .utf8)
        let isBackSpace = strcmp(utf8Char, "\\b")
        if string.checkNickname() || isBackSpace == -92 {
            return true
        }
        return false
    }
}

// MARK: - IntroTextDelegate

extension EditMyProfileVC: IntroTextDelegate {
    func getTextView(text: String) {
        self.introText = text
        checkComplete()
    }
}

// MARK: - Network

extension EditMyProfileVC {
    
    private func getAccountAPI() {
        MyPageAPI(viewController: self).getMyAccountInfo { response in
            if response?.success == true {
                guard let serverGetAccountDetail = response?.data else { return }
                self.profileImageView.loadProfileImage(from: response?.data?.profileImage)
            }
        }
    }
    
    private func editMyProfile(request: PatchProfileRequest, image: UIImage?) {
        var finalImage: UIImage? = image
        if isImageDefaultType {
            finalImage = nil
        }
        MyPageAPI(viewController: self).editMyProfile(request: request, image: finalImage) { response in
            if response?.success == true {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func checkDuplicateComplete(param: CheckDuplicateRequest, completion: @escaping (Bool) -> Void) {
        UserAPI(viewController: self).checkDuplicate(param: param) { response in
            if response?.success == true {
                if let isDuplicated = response?.data?.check {
                    if isDuplicated == 0 {
                        self.isDoubleChecked = true
                        completion(true)
                    } else {
                        self.isDoubleChecked = false
                        completion(false)
                    }
                }
            }
        }
    }
}
