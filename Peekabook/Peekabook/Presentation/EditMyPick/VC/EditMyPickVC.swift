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
    
    private var serverBookList: [PickAllResponse]?

    private var books: [EachBook] = []
    private var pickedBooksList: [Int] = Array(repeating: -1, count: 3) {
        didSet {
            bookShelfCollectionView.reloadData()
        }
    }
    
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
        collectionView.allowsMultipleSelection = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllPicks()
    }
    
    // MARK: - @objc Function
    
    @objc
    private func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func completeButtonDidTap() {
        guard let serverBookList = serverBookList else { return }
        var selectedBookIdList = pickedBooksList.map { index in
            serverBookList[index].id
        }
        let paddingCount = 3 - selectedBookIdList.count
        selectedBookIdList.append(contentsOf: Array(repeating: 0, count: paddingCount))
        patchPickList(param: EditPickRequest(firstPick: selectedBookIdList[0],
                                             secondPick: selectedBookIdList[1],
                                             thirdPick: selectedBookIdList[2]))
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
        
        naviContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(65)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
        }
        
        bookShelfCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviContainerView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPickCVC.className, for: indexPath)
                as? EditPickCVC else { return UICollectionViewCell() }
        var pickIndex = -1
        if let selectedBookIndex = pickedBooksList.firstIndex(of: indexPath.item) {
            pickIndex = selectedBookIndex
        }
        cell.setData(model: books[indexPath.row], pickIndex: pickIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard collectionView.cellForItem(at: indexPath) as? EditPickCVC != nil else { return }
                
        if let selectedBookIndex = pickedBooksList.firstIndex(of: indexPath.item) {
            pickedBooksList.remove(at: selectedBookIndex)
            return
        }
        guard pickedBooksList.count < 3 else { return }
        
        pickedBooksList.append(indexPath.item)
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

// MARK: - Network

extension EditMyPickVC {
    func getAllPicks() {
        PickAPI.shared.getAllPicks { response in
            guard let response = response, let data = response.data else { return }
            self.serverBookList = response.data

            var count = 0
            
            for i in 0..<data.count {
                self.books.append(data[i].book)
                if data[i].pickIndex != 0 {
                    count += 1
                    self.pickedBooksList[data[i].pickIndex - 1] = i
                }
            }
            self.pickedBooksList = Array(self.pickedBooksList[0..<count])
        }
    }
    
    func patchPickList(param: EditPickRequest) {
        PickAPI.shared.patchPickList(param: param) { response in
            if response?.success == true {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showToast(message: I18N.Alert.networkError)
            }
        }
    }
}
