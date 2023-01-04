//
//  BookShelfVC.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import SnapKit
import Then

import Moya

final class BookShelfVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        addBottomSheetView()
    }
}

// MARK: - UI & Layout
extension BookShelfVC {
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        
    }
}

// MARK: - Methods

extension BookShelfVC {
    private func addBottomSheetView(scrollable: Bool? = true) {
        let bottomShelfVC = BottomBookShelfVC()
        
        self.view.addSubview(bottomShelfVC.view)
        
        self.addChild(bottomShelfVC)
        
        bottomShelfVC.didMove(toParent: self)

        let height = view.frame.height
        let width = view.frame.width
        
        bottomShelfVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }

}
