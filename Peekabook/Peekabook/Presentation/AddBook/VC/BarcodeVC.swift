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
    
    // MARK: - Properties
    
    var searchType: SearchType = .camera
    var isbnCode: String = ""
    var displayCount: Int = 100
    var publisher: String = ""
    
    // MARK: - UI Components
    
    private let descriptionLabel = UILabel().then {
        $0.text = I18N.Barcode.infoLabel
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.textColor = .peekaWhite
        $0.font = .h2
    }
    
    private lazy var textSearchButton = UIButton().then {
        $0.setTitle(I18N.Barcode.infoButton, for: .normal)
        $0.titleLabel!.font = .s3
        $0.setTitleColor(.peekaWhite, for: .normal)
        $0.addTarget(self, action: #selector(textSearchButtonDidTap), for: .touchUpInside)
    }

    private let textSearchCircle = UIView().then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.peekaWhite.cgColor
        $0.layer.cornerRadius = 13
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDelegate()
        setLayout()
    }
}

// MARK: - UI & Layout

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
            textSearchButton,
            textSearchCircle
        ])
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(textSearchButton.snp.top).offset(-25)
            $0.centerX.equalToSuperview()
        }
        
        textSearchButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(175)
            $0.centerX.equalToSuperview()
        }
        
        textSearchCircle.snp.makeConstraints {
            $0.leading.trailing.equalTo(textSearchButton).inset(-12)
            $0.height.equalTo(26)
            $0.center.equalTo(textSearchButton)
        }
    }
}

// MARK: - Methods

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
        let errorPopUpVC = BookSearchErrorPopUpVC()
        errorPopUpVC.modalPresentationStyle = .overFullScreen
        self.present(errorPopUpVC, animated: false)
    }
}

// MARK: - BarcodeScannerCodeDelegate

extension BarcodeVC: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
        if type != "org.gs1.EAN-13" {
            showErrorPopUp()
        } else {
            getNaverSearchedBooks(d_titl: "", d_isbn: "\(code)", display: displayCount)
        }
    }
}

// MARK: - BarcodeScannerDismissalDelegate

extension BarcodeVC: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - BarcodeScannerErrorDelegate

extension BarcodeVC: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - Network

extension BarcodeVC {
    
    private func getNaverSearchedBooks(d_titl: String, d_isbn: String, display: Int) {
        NaverSearchAPI(viewController: self).getNaverSearchedBooks(d_titl: d_titl, d_isbn: d_isbn, display: display) { response in
            if let response = response, !response.isEmpty {
                let addBookVC = AddBookVC()
                addBookVC.searchType = .camera
                
                if let info = response.first {
                    let bookInfo = BookInfoModel(title: info.title,
                                                 image: info.image,
                                                 author: info.author,
                                                 publisher: info.publisher)
                    addBookVC.bookInfo = [bookInfo]
                    addBookVC.dataBind(model: bookInfo)
                }
                
                addBookVC.modalPresentationStyle = .fullScreen
                self.present(addBookVC, animated: true, completion: nil)
            } else {
                self.showErrorPopUp()
            }
        }
    }
}
