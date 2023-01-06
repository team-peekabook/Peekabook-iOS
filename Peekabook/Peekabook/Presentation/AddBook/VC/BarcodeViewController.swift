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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let viewController = BarcodeScannerViewController()
        viewController.headerViewController.closeButton.setImage(UIImage(named: "search"), for: .normal)
        viewController.headerViewController.closeButton.setTitle("", for: .normal)
        viewController.headerViewController.titleLabel.text = "책 검색하기"
        
        codeDelegate = self
        setLayout()
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
