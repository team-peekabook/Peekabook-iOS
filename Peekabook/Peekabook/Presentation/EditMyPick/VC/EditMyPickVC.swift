//
//  EditMyPickVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import SnapKit
import Then

import Moya

final class EditMyPickVC: UIViewController {
    
    // MARK: - Properties
    
    private var editPickModelList = SampleEditPickModel.data

    // MARK: - UI Components
    
    private let naviContainerView = UIView()

    private lazy var backButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.back, for: .normal)
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var completeButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.check, for: .normal)
        $0.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = I18N.BookShelf.editPickDescription
        $0.font = .s1
        $0.textColor = .peekaRed
        $0.textAlignment = .left
    }
    
    private lazy var bookShelfCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
    }
    
    // MARK: - @objc Function
    
    @objc
    private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func completeButtonDidTap() {
        print("confirmButtonDidTap")
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UI & Layout
extension EditMyPickVC {
    
    private func setUI() {
        view.backgroundColor = .peekaWhite
        bookShelfCollectionView.backgroundColor = .peekaWhite
    }
    
    private func setLayout() {
        view.addSubviews(naviContainerView, bookShelfCollectionView)
        naviContainerView.addSubviews(backButton, completeButton, descriptionLabel)
        
        naviContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(65)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.leading.equalToSuperview().offset(20)
        }
        
        bookShelfCollectionView.snp.makeConstraints { make in
            make.top.equalTo(naviContainerView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension EditMyPickVC {
    
    private func setDelegate() {
        bookShelfCollectionView.delegate = self
        bookShelfCollectionView.dataSource = self
    }
    
    private func registerCells() {
        bookShelfCollectionView.register(EditPickCVC.self, forCellWithReuseIdentifier: EditPickCVC.className)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension EditMyPickVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return editPickModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPickCVC.className, for: indexPath)
                as? EditPickCVC else { return UICollectionViewCell() }
        cell.initCell(model: editPickModelList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout

extension EditMyPickVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (collectionView.frame.width - 10) / 3
        return CGSize(width: length - 10, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
