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
    
    private let labelA = UILabel().then {
        $0.text = "테스트입니다"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let viewController = BarcodeScannerViewController()
//        viewController.headerViewController.closeButton.setImage(UIImage(named: "search"), for: .normal)
//        viewController.headerViewController.closeButton.setTitle("", for: .normal)
//        viewController.headerViewController.closeButton.setImage(ImageLiterals.Icn.close, for: .normal)
//        viewController.headerViewController.closeButton.setTitleColor(.red, for: .normal)
//        viewController.headerViewController.titleLabel.text = "책 검색하기"
        viewController.headerViewController.titleLabel.text = "example"
        
        viewController.cameraViewController.focusView.layer.borderWidth = 2
        viewController.cameraViewController.focusView.layer.borderColor = UIColor(red: 0.565, green: 0.169, blue: 0.129, alpha: 1).cgColor
        
        viewController.modalPresentationStyle = .fullScreen
        viewController.cameraViewController.barCodeFocusViewType = .twoDimensions // 바코드 규격 스타일
        viewController.cameraViewController.focusView.transform = CGAffineTransform(scaleX: 1.5, y: 1.3)
        viewController.cameraViewController.flashButton.transform = CGAffineTransform(scaleX: 0, y: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let viewController = BarcodeScannerViewController()
//        viewController.headerViewController.closeButton.setImage(UIImage(named: "search"), for: .normal)
//        viewController.headerViewController.closeButton.setTitle("", for: .normal)
//        viewController.headerViewController.closeButton.setImage(ImageLiterals.Icn.close, for: .normal)
//        viewController.headerViewController.closeButton.setTitleColor(.red, for: .normal)
//        viewController.headerViewController.titleLabel.text = "책 검색하기"
        viewController.headerViewController.titleLabel.text = "example"
        
        viewController.cameraViewController.focusView.layer.borderWidth = 2
        viewController.cameraViewController.focusView.layer.borderColor = UIColor(red: 0.565, green: 0.169, blue: 0.129, alpha: 1).cgColor
        
        viewController.modalPresentationStyle = .fullScreen
        viewController.cameraViewController.barCodeFocusViewType = .twoDimensions // 바코드 규격 스타일
        viewController.cameraViewController.focusView.transform = CGAffineTransform(scaleX: 1.5, y: 1.3)
        viewController.cameraViewController.flashButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        codeDelegate = self
        setLayout()
        dismissalDelegate = self
    }
}

extension BarcodeViewController {
    private func setLayout() {
        view.addSubview(labelA)
        
        labelA.snp.makeConstraints {
            $0.top.equalToSuperview().offset(500)
            $0.leading.equalToSuperview().offset(200)
        }
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
