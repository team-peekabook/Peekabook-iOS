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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetWithError(message: "다시 스캔합니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDelegate()
        setLayout()
        setActions()
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
    
    private func setActions() {
        headerViewController.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
    private func setLayout() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .peekaBeige
        
        view.addSubviews([
            topBackgroundView,
            descriptionLabel,
            headerViewController.view
        ])
        
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        headerViewController.view.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        
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
        self.navigationController?.pushViewController(errorPopUpVC, animated: false)
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
//        controller.dismiss(animated: true, completion: nil)
        closeButtonTapped()
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
                
                self.navigationController?.pushViewController(addBookVC, animated: false)

            } else {
                self.showErrorPopUp()
            }
        }
    }
}
