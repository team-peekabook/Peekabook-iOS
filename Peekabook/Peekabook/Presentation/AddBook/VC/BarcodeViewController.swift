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
    
    private lazy var infoButton = UIButton().then {
        $0.setTitle("바코드 인식이 어려우신가요?", for: .normal)
        $0.titleLabel!.font = .c2
        $0.setTitleColor(.peekaWhite, for: .normal)
        $0.addTarget(self, action: #selector(touchinfoButtonDidTap), for: .touchUpInside)
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
    }
    
    private func setLayout() {
        view.addSubviews([
            infoLabel,
            infoButton
        ])
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(540)
            make.centerX.equalToSuperview()
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(140)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        dismissalDelegate = self
        codeDelegate = self
    }
    
    @objc private func touchinfoButtonDidTap() {
        let nextVC = BookSearchVC()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
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
