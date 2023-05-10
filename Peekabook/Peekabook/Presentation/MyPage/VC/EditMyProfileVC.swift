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
    
    private let dummyName: String = "북과빅"
    
    var nicknameText: String = UserDefaults.standard.string(forKey: "userNickname") ?? ""
    var introText: String = UserDefaults.standard.string(forKey: "userIntro") ?? ""
    var userImage: String = UserDefaults.standard.string(forKey: "userImage") ?? ""
    
    var isDoubleChecked: Bool = true {
        didSet {
            if isDoubleChecked {
                doubleCheckButton.backgroundColor = .peekaGray1
            } else {
                doubleCheckButton.backgroundColor = .peekaRed
            }
        }
    }
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton)
        .addMiddleLabel(title: I18N.Profile.editmyPage)
        .addRightButton(with: I18N.BookProposal.done)
        .addRightButtonAction {
            self.checkButtonDidTap()
        }
    
    private let profileImageContainerView = UIView()
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
    }
    private lazy var editImageButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.profileImageEdit, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(ImagePickDidTap), for: .touchUpInside)
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
        $0.text = UserDefaults.standard.string(forKey: "userNickname")
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    private lazy var doubleCheckButton = UIButton(type: .system).then {
        $0.setTitle(I18N.Profile.doubleCheck, for: .normal)
        $0.backgroundColor = .peekaGray1
        $0.setTitleColor(.peekaWhite, for: .normal)
        $0.titleLabel?.font = .c1
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
        if let name = UserDefaults.standard.string(forKey: "userNickname") {
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
        introContainerView.updateTextView(type: .editProfileIntro)
        introContainerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAccountAPI()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let nicknameText = textField.text else { return }
        
        // 기존 닉네임 값과 동일하거나 빈 경우 -> 중복확인 불가
        if UserDefaults.standard.string(forKey: "userNickname") != nicknameText && !nicknameText.isEmpty {
            doubleCheckButton.backgroundColor = .peekaRed
            isDoubleChecked = false
        } else {
            doubleCheckButton.backgroundColor = .peekaGray1
            isDoubleChecked = true
        }
        
        if nicknameText.count > 6 {
            textField.deleteBackward()
        } else {
            countMaxTextLabel.text = "\(nicknameText.count)\(I18N.Profile.nicknameLength)"
        }
        
        doubleCheckErrorLabel.isHidden = true
        doubleCheckSuccessLabel.isHidden = true
        
        // 항상 값을 최신화
        self.nicknameText = nicknameText
        checkComplete()
    }
    
    @objc private func doubleCheckButtonDidTap() {
        let isDuplicated = checkIfDuplicated(nicknameTextField.text)
        if isDuplicated {
            doubleCheckButton.backgroundColor = .peekaRed
            doubleCheckErrorLabel.isHidden = false
            doubleCheckSuccessLabel.isHidden = true
        } else {
            doubleCheckButton.backgroundColor = .peekaGray1
            doubleCheckErrorLabel.isHidden = true
            doubleCheckSuccessLabel.isHidden = false
            isDoubleChecked = true
        }
        checkComplete()
    }
    
    @objc private func checkButtonDidTap() {
        // TODO: 기본이미지로 변경하는 부분은 얼럿이 아직 없어서 못했음. 추후에 반영해야 됨
        editMyProfile(request: PatchProfileRequest(nickname: nicknameTextField.text ?? "",
                                                   intro: introText),
                      image: profileImageView.image)
    }
    
    private func checkComplete() {
        if !self.nicknameText.isEmpty && !self.introText.isEmpty && isDoubleChecked {
            naviBar.isProfileEditComplete = true
        } else {
            naviBar.isProfileEditComplete = false
        }
    }
    
    func checkIfDuplicated(_ text: String?) -> Bool {
        if text != dummyName {
            return false
        } else {
            return true
        }
    }
    
    @objc private func ImagePickDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (action) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "앨범", style: .default, handler: { (action) in
            self.openPhotoLibrary()
        }))
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
    
}

extension EditMyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.profileImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UI & Layout

extension EditMyProfileVC {
    
    private func setBackgroundColor() {
        view.backgroundColor = .peekaBeige
        nicknameHeaderView.backgroundColor = .peekaRed
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, profileImageContainerView, nicknameContainerView, doubleCheckErrorLabel, doubleCheckSuccessLabel, countMaxTextLabel, introContainerView)
        profileImageContainerView.addSubviews(profileImageView, editImageButton)
        nicknameContainerView.addSubviews(nicknameHeaderView, nicknameTextContainerView)
        nicknameHeaderView.addSubviews(nicknameLabel)
        nicknameTextContainerView.addSubviews(nicknameTextField, doubleCheckButton)
    
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        profileImageContainerView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(82)
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
            $0.leading.trailing.equalToSuperview().inset(20)
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
            $0.leading.equalToSuperview()
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
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.height.equalTo(101)
        }
    }
}

extension EditMyProfileVC: IntroText {
    func getTextView(text: String) {
        self.introText = text
        checkComplete()
    }
}

// MARK: - Network

extension EditMyProfileVC {
    
    private func getAccountAPI() {
        MyPageAPI.shared.getMyAccountInfo { response in
            if response?.success == true {
                guard let serverGetAccountDetail = response?.data else { return }
                self.profileImageView.kf.indicatorType = .activity
                self.profileImageView.kf.setImage(with: URL(string: serverGetAccountDetail.profileImage))
                
                if response?.data?.profileImage.isEmpty == true {
                    self.profileImageView.image = ImageLiterals.Icn.emptyProfileImage
                }
            }
        }
    }
    
    private func editMyProfile(request: PatchProfileRequest, image: UIImage?) {
        MyPageAPI.shared.editMyProfile(request: request, image: image) { response in
            if response?.success == true {
                self.switchRootViewController(rootViewController: TabBarController(), animated: true, completion: nil)
            }
        }
    }
}
