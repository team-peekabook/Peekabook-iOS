//
//  BookShelfCVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

import SnapKit

final class BookShelfCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var bookId: Int = 0
    
    // MARK: - UI Components
    
    private let bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
    private let horizontalLine: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        return view
    }()
    
    private let pickImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiterals.Icn.newPick
        iv.contentMode = .scaleToFill
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
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

// MARK: - UI & Layout

extension BookShelfCVC {
    
    private func setUI() {
        backgroundColor = .peekaLightBeige
        horizontalLine.backgroundColor = .peekaBeige
        bookImageView.layer.applyShadow(color: .black, alpha: 0.25, x: 1, y: 1, blur: 4, spread: 0)
    }
    
    private func setLayout() {
        addSubviews(bookImageView, horizontalLine, pickImageView)
        
        bookImageView.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(150)
        }
        
        horizontalLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bookImageView.snp.bottom)
            $0.width.equalTo(UIScreen.main.bounds.width*2)
            $0.height.equalTo(6)
        }
        
        pickImageView.snp.makeConstraints {
            $0.top.equalTo(bookImageView.snp.top).offset(-4)
            $0.trailing.equalTo(bookImageView).inset(8)
        }
    }
}

// MARK: - Methods

extension BookShelfCVC {
    
    func setData(model: Book) {
        pickImageView.isHidden = model.pickIndex == 0 ? true : false
        bookId = model.bookID
        bookImageView.kf.indicatorType = .activity
        bookImageView.kf.setImage(with: URL(string: model.book.bookImage))
    }
}
