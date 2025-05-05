import UIKit

enum CustomSearchType: CaseIterable {
    case userSearch
    case bookSearch
}

final class CustomSearchView: UIView {

    // MARK: - UI Components
    
    private let type: CustomSearchType
    private weak var viewController: UIViewController?
    private let searchContainerView = UIView()

    private let searchImgView = UIImageView().then {
        $0.image = ImageLiterals.Icn.searchGrey
    }

    private lazy var searchButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.search, for: .normal)
    }

    private lazy var barcodeButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.barcode, for: .normal)
        $0.isHidden = false
    }

    private lazy var cancelButton = UIButton().then {
        $0.setImage(ImageLiterals.Icn.cancel, for: .normal)
        $0.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        $0.isHidden = true
    }

    private let searchTextField = UITextField().then {
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.returnKeyType = .done
        $0.autocorrectionType = .no
    }

    // MARK: - Init
    
    init(frame: CGRect, type: CustomSearchType, viewController: UIViewController) {
        self.type = type
        self.viewController = viewController
        super.init(frame: frame)
        setBackgroundColor()
        setLayout()
        setCustomSearchView(type: type)
        
        searchTextField.delegate = self
        if type == .userSearch {
            searchTextField.addLeftPadding()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showKeyboard() {
        searchTextField.becomeFirstResponder()
    }
}

// MARK: - Layout & Style

extension CustomSearchView {

    private func setBackgroundColor() {
        backgroundColor = .clear
        searchContainerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        searchButton.backgroundColor = .white.withAlphaComponent(0.4)
        searchImgView.backgroundColor = .white.withAlphaComponent(0.4)
        searchTextField.backgroundColor = .white.withAlphaComponent(0.4)
        barcodeButton.backgroundColor = .white.withAlphaComponent(0.4)
        cancelButton.backgroundColor = .white.withAlphaComponent(0.4)
    }

    private func setLayout() {
        addSubview(searchContainerView)

        searchContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }

        if type == .bookSearch { // 책검색
            [searchImgView, searchTextField, barcodeButton, cancelButton].forEach {
                searchContainerView.addSubview($0)
            }

            searchImgView.snp.makeConstraints {
                $0.leading.top.bottom.equalToSuperview()
                $0.width.equalTo(40)
            }

            barcodeButton.snp.makeConstraints {
                $0.trailing.top.bottom.equalToSuperview()
                $0.width.equalTo(40)
            }

            cancelButton.snp.makeConstraints {
                $0.trailing.top.bottom.equalToSuperview()
                $0.width.equalTo(40)
            }
            //
            searchTextField.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalTo(searchImgView.snp.trailing).offset(-4)
                $0.trailing.equalToSuperview().offset(-40) // 버튼 너비만큼 여백
            }

            barcodeButton.snp.makeConstraints {
                $0.trailing.top.bottom.equalToSuperview()
                $0.width.equalTo(40)
            }

            cancelButton.snp.makeConstraints {
                $0.trailing.top.bottom.equalToSuperview()
                $0.width.equalTo(40)
            }
            
        } else { // 사용자검색 (우측에만)
            [searchButton, searchTextField].forEach {
                searchContainerView.addSubview($0)
            }

            searchButton.snp.makeConstraints {
                $0.trailing.top.bottom.equalToSuperview()
                $0.width.equalTo(40)
            }

            searchTextField.snp.makeConstraints {
                $0.leading.top.bottom.equalToSuperview()
                $0.trailing.equalTo(searchButton.snp.leading)
            }
        }
    }
}

// MARK: - Public Interface

extension CustomSearchView {

    func setCustomSearchView(type: CustomSearchType) {
        switch type {
        case .userSearch:
            searchButton.addTarget(viewController, action: #selector(UserSearchVC.searchBtnTapped), for: .touchUpInside)
            searchTextField.placeholder = I18N.PlaceHolder.userSearch
        case .bookSearch:
            barcodeButton.addTarget(viewController, action: #selector(barcodeButtonDidTap), for: .touchUpInside)
            searchTextField.placeholder = I18N.PlaceHolder.bookSearch
        }
    }

    var text: String? {
        return searchTextField.text
    }

    func hasSearchText() -> Bool {
        return searchTextField.hasText
    }

    func setSearchTextFieldDelegate(_ delegate: UITextFieldDelegate) {
//        searchTextField.delegate = delegate
        searchTextField.delegate = self

    }

    func endEditing() {
        searchTextField.endEditing(true)
    }

    private func updateButtonState() {
        let isTextEntered = hasSearchText()
        barcodeButton.isHidden = isTextEntered
        cancelButton.isHidden = !isTextEntered
    }

    @objc private func barcodeButtonDidTap() {
        let barcodeVC = BarcodeVC()
        barcodeVC.modalPresentationStyle = .fullScreen
        viewController?.present(barcodeVC, animated: true)
    }

    @objc private func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        updateButtonState()
    }
}

// MARK: - UITextFieldDelegate

extension CustomSearchView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("111")
        updateButtonState()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("2222")

        updateButtonState()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        if let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string) as String? {
            DispatchQueue.main.async {
                let hasText = !updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                self.barcodeButton.isHidden = hasText
                self.cancelButton.isHidden = !hasText
            }
        }
        return true
    }
}
