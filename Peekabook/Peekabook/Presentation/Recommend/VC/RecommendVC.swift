//
//  RecommendVC.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

import SnapKit
import Then

import Moya

final class RecommendVC: UIViewController {

    // MARK: - Properties

    var menuName: [String] = ["추천받은 책", "추천한 책"]
    
    // MARK: - UI Components
    
    private let headerView = UIView()
    private let logoImage = UIImageView().then {
        $0.image = UIImage(named: "peekabook_logo")
    }
    
    // Menu Tab
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 17
        $0.sectionInset = UIEdgeInsets(top: 16, left: 22, bottom: 24, right: 22)
    }

    lazy var menuCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.allowsMultipleSelection = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        register()
    }
}

// MARK: - UI & Layout

extension RecommendVC {
    
    private func register() {
        menuCollectionView.register(TabMenuCollectionViewCell.self, forCellWithReuseIdentifier: TabMenuCollectionViewCell.identifier)
    }
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews([headerView, menuCollectionView])
        headerView.addSubview(logoImage)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        logoImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(150)
            $0.height.equalTo(18)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(63)
        }
    }
}

// MARK: - Methods

extension RecommendVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabMenuCollectionViewCell.identifier, for: indexPath) as? TabMenuCollectionViewCell else { return UICollectionViewCell() }
        cell.dataBind(menuLabel: menuName[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 23)
    }
}
