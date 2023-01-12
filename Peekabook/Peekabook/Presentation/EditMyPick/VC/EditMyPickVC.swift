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
    var pickCount: Int?
    
    private var editPickModelList = SampleEditPickModel.data
    private var serverPickLists: [PickAllResponse]?
    
    private var firstPick: Int = 0
    private var secondPick: Int = 0
    private var thirdPick: Int = 0

    private var books: [EachBook] = []

    private var selectedPickList: [Int] = []

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
        
        if selectedPickList.isEmpty {
            firstPick = 0
            secondPick = 0
            thirdPick = 0
        } else if selectedPickList.count == 1 {
            firstPick = books[selectedPickList[0]].id
            secondPick = 0
            thirdPick = 0
        } else if selectedPickList.count == 2 {
            firstPick = books[selectedPickList[0]].id
            secondPick = books[selectedPickList[1]].id
            thirdPick = 0
        } else {
            firstPick = books[selectedPickList[0]].id
            secondPick = books[selectedPickList[1]].id
            thirdPick = books[selectedPickList[2]].id
        }
        patchPickList(param: EditPickRequest(firstPick: firstPick, secondPick: secondPick, thirdPick: thirdPick))
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
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditPickCVC.className, for: indexPath)
                as? EditPickCVC else { return UICollectionViewCell() }
        cell.setData(model: books[indexPath.row], pickIndex: serverPickLists?[indexPath.row].pickIndex ?? 0)
        cell.initialLayout(model: editPickModelList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? EditPickCVC
        
        if selectedPickList.count < 3 {
            
            if selectedPickList.contains(indexPath.row) {
                guard let index = selectedPickList.firstIndex(of: indexPath.row) else { return }
                selectedPickList.remove(at: index)
                cell?.deselectedLayout()
                selectedPickList.forEach {
                    let cell = collectionView.cellForItem(at: [0, $0]) as? EditPickCVC
                    guard let newIndex = selectedPickList.firstIndex(of: $0) else { return }
                    cell?.plusCountLabel(index: newIndex)
                }
            } else {
                selectedPickList.append(indexPath.row)
                guard let index = selectedPickList.firstIndex(of: indexPath.row) else { return }
                cell?.selectedLayout(index: index)
            }
        } else {
            if selectedPickList.contains(indexPath.row) {
                guard let index = selectedPickList.firstIndex(of: indexPath.row) else { return }
                selectedPickList.remove(at: index)
                cell?.deselectedLayout()
                selectedPickList.forEach {
                    let cell = collectionView.cellForItem(at: [0, $0]) as? EditPickCVC
                    guard let newIndex = selectedPickList.firstIndex(of: $0) else { return }
                    cell?.plusCountLabel(index: newIndex)
                }
            }
        }
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
            self.serverPickLists = response?.data
            
            guard let response = response, let data = response.data else { return }
            
            guard let pickCount = self.pickCount else { return }
            
            var temp = [Int](repeating: 0, count: pickCount)
            for i in 0..<data.count {
                self.books.append(data[i].book)
                if data[i].pickIndex != 0 {
                    temp[data[i].pickIndex - 1] = i
                }
            }
            self.selectedPickList = temp
        
            self.bookShelfCollectionView.reloadData()
        }
    }
    
    func patchPickList(param: EditPickRequest) {
        PickAPI.shared.patchPickList(param: param) { response in
            if response?.success == true {
                print("edit pick success")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("edit pick fail")
                // 실패 토스트 띄우기
            }
        }
    }
}
