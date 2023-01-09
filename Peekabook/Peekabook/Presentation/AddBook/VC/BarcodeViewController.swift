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
        $0.text = I18N.Barcode.infoLabel
        $0.numberOfLines = 2
        $0.textColor = .peekaWhite
        $0.font = .h2
    }
    
    private lazy var textSearchButton = UIButton().then {
        $0.setTitle(I18N.Barcode.infoButton, for: .normal)
        $0.titleLabel!.font = .c2
        $0.setTitleColor(.peekaWhite, for: .normal)
        $0.addTarget(self, action: #selector(touchtextSearchButtonDidTap), for: .touchUpInside)
        $0.setUnderline()
    }
    
    private let lineView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDelegate()
        setLayout()
    }
}

extension BarcodeViewController {
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
            infoLabel,
            textSearchButton
        ])
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(540)
            make.centerX.equalToSuperview()
        }
        
        textSearchButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(140)
            make.centerX.equalToSuperview()
        }
    }
}

extension BarcodeViewController {
    private func setDelegate() {
        dismissalDelegate = self
        codeDelegate = self
        errorDelegate = self
    }
    
    @objc private func touchtextSearchButtonDidTap() {
//        let nextVC = BookSearchVC()
//        nextVC.modalPresentationStyle = .fullScreen
//        self.present(nextVC, animated: true, completion: nil)
        let nextVC = ErrorPopUpViewController()
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: false)
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

extension BarcodeViewController: BarcodeScannerErrorDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
    print(error)
  }
}

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
