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
            descriptionLabel
        ])
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(200)
            $0.centerX.equalToSuperview()
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
            getNaverSearchedBooks(query: "", d_isbn: "\(code)", display: displayCount)
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
    
    private func getNaverSearchedBooks(query: String, d_isbn: String, display: Int) {
        NaverSearchAPI(viewController: self).getNaverSearchedBooks(query: query, d_isbn: d_isbn, display: display) { response in
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
