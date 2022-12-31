//
//  setClearButton.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension UITextField {
    
    func setClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 18))
        rightView.addSubview(clearButton)
        
        self.rightView = rightView
        self.rightViewMode = .whileEditing
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
    }
}
