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

final class BarcodeViewController: BarcodeScannerViewController {
    
    private let infoLabel = UILabel().then {
        $0.text = "책의 뒷면에 있는 ISBN 바코드가\n사각형 안에 들어오게 해주세요."
        $0.numberOfLines = 0
        $0.textColor = .white
        $0.font = .h2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .peekaBeige
        
        headerViewController.titleLabel.text = "책 검색하기"
        headerViewController.titleLabel.textColor = .peekaRed
        headerViewController.titleLabel.font = .h3
        
        headerViewController.closeButton.setImage(ImageLiterals.Icn.close, for: .normal)
        headerViewController.closeButton.setTitle("", for: .normal)

        cameraViewController.focusView.layer.borderWidth = 2
        cameraViewController.focusView.layer.borderColor = UIColor.peekaRed.cgColor
        cameraViewController.barCodeFocusViewType = .twoDimensions
        cameraViewController.focusView.transform = CGAffineTransform(scaleX: 1.6, y: 1.25)
        cameraViewController.flashButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        setDelegate()
        setLayout()
    }
}

extension BarcodeViewController {
    private func setLayout() {
        view.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(540)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        dismissalDelegate = self
        codeDelegate = self
    }
}

extension BarcodeViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
      print("Barcode Data: \(code)")
      print("Symbology Type: \(type)")
        let nextVC = AddBookVC()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}

extension BarcodeViewController: BarcodeScannerDismissalDelegate {
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
