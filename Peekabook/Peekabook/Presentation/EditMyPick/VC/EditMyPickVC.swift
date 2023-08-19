//
//  EditMyPickVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/01.
//

import UIKit

import Moya
import SnapKit

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
    
    private lazy var navibar = CustomNavigationBar(self, type: .oneLeftButtonWithOneRightButton, backgroundColor: .white)
        .addRightButton(with: ImageLiterals.Icn.check)
        .addRightButtonAction {
            self.completeButtonDidTap()
        }
    
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.text = I18N.BookShelf.editPickDescription
        lb.font = .s1
        lb.textColor = .peekaRed
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var bookShelfCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.bounces = false
        cv.allowsMultipleSelection = true
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
        getAllPicks()
    }
    
    // MARK: - @objc Function
    
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
        naviContainerView.addSubviews(navibar, descriptionLabel)
        
        naviContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(72)
        }
        
        navibar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom).inset(2)
            $0.leading.equalToSuperview().offset(20)
        }
        
        bookShelfCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviContainerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
        cell.setData(model: books[safe: indexPath.row]!, pickIndex: pickIndex)
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
        PickAPI(viewController: self).getAllPicks { response in
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
        PickAPI(viewController: self).patchPickList(param: param) { response in
            if response?.success == true {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showToast(message: I18N.Alert.networkError)
            }
        }
    }
}
