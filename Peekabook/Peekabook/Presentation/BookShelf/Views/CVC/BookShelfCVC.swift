//
//  BookShelfCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

final class BookShelfCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension BookShelfCVC {
    func initCell(model: SampleBookModel) {
        bookImageView.image = model.bookImage
    }
    
    private func setUI() {
        self.backgroundColor = .peekaLightBeige
    }
    
    private func setLayout() {
        addSubview(bookImageView)
        
        bookImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
    }
}
