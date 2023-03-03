//
//  BarcodeViewController.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/06.
//

import UIKit

import BarcodeScanner
import SnapKit
import Then

final class BarcodeVC: BarcodeScannerViewController {
    
    var bookInfoList: [BookInfoModel] = []
    var isbnCode: String = ""
    var displayCount: Int = 100
    
    private let descriptionLabel = UILabel().then {
        $0.text = I18N.Barcode.infoLabel
        $0.numberOfLines = 2
        $0.textColor = .peekaWhite
        $0.font = .s3
    }
    
    private lazy var textSearchButton = UIButton().then {
        $0.setTitle(I18N.Barcode.infoButton, for: .normal)
        $0.titleLabel!.font = .c2
        $0.setTitleColor(.peekaWhite, for: .normal)
        $0.addTarget(self, action: #selector(textSearchButtonDidTap), for: .touchUpInside)
        $0.setUnderline()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDelegate()
        setLayout()
    }
}

extension BarcodeVC {
    private func setUI() {
        view.backgroundColor = .peekaBeige

        headerViewController.titleLabel.text = I18N.Barcode.searchLabel
        headerViewController.titleLabel.textColor = .peekaRed
        headerViewController.titleLabel.font = .h3
        
        headerViewController.closeButton.setImage(ImageLiterals.Icn.close, for: .normal)
        headerViewController.closeButton.setTitle("", for: .normal)

        cameraViewController.focusView.layer.borderWidth = 2
        cameraViewController.focusView.layer.borderColor = UIColor.peekaRed.cgColor
        cameraViewController.barCodeFocusViewType = .twoDimensions
        cameraViewController.focusView.transform = CGAffineTransform(scaleX: 1.6, y: 1.25)
        cameraViewController.flashButton.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    private func setLayout() {
        view.addSubviews([
            descriptionLabel,
            textSearchButton
        ])
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(textSearchButton.snp.top).offset(-100)
            $0.centerX.equalToSuperview()
        }
        
        textSearchButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func fetchBooks() {
        let ls = NaverSearchAPI.shared
        ls.getNaverSearchData(d_titl: "", d_isbn: "\(isbnCode)", display: displayCount) { [weak self] result in
            if let result = result {
                self?.bookInfoList = [BookInfoModel(image: "", title: "", author: "")]
                DispatchQueue.main.async {
                    let nextVC = AddBookVC()
                    nextVC.bookInfo = [BookInfoModel(image: "", title: "", author: "")]
                    nextVC.modalPresentationStyle = .fullScreen
                    
                    if [BookInfoModel(image: "", title: "", author: "")].isEmpty {
                        self?.showErrorPopUp()
                    } else {
                        nextVC.dataBind(model: [BookInfoModel(image: "", title: "", author: "")][0])
                        self?.present(nextVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension BarcodeVC {
    private func setDelegate() {
        dismissalDelegate = self
        codeDelegate = self
        errorDelegate = self
    }
    
    @objc private func textSearchButtonDidTap() {
        let nextVC = BookSearchVC()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func showErrorPopUp() {
        let errorPopUpVC = ErrorPopUpVC()
        errorPopUpVC.modalPresentationStyle = .overFullScreen
        self.present(errorPopUpVC, animated: false)
    }
}

extension BarcodeVC: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")

        if type != "org.gs1.EAN-13" {
            let errorPopUpVC = ErrorPopUpVC()
            errorPopUpVC.modalPresentationStyle = .overFullScreen
            self.present(errorPopUpVC, animated: false)
        }
        
        isbnCode = code
        fetchBooks()
    }
}

extension BarcodeVC: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension BarcodeVC: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}
