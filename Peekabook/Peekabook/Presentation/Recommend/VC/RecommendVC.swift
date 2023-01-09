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

    private var recommendTypes: [String] = ["추천받은 책", "추천한 책"]
    
    // MARK: - Properties
    
    private let recommendedVC = RecommendedVC()
    private let recommendingVC = RecommendingVC()
    private lazy var dataViewControllers: [UIViewController] = {
        return [recommendedVC, recommendingVC]
    }()

    private var currentPage: Int = 0 {
        didSet {
            bind(newValue: currentPage)
        }
    }
    
    // MARK: - UI Components
    
    private let headerView = UIView()
    private let logoImage = UIImageView().then {
        $0.image = UIImage(named: "peekabook_logo")
    }
    private let headerUnderlineView = UIView()
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 17
        $0.sectionInset = UIEdgeInsets(top: 16, left: 22, bottom: 24, right: 22)
    }
    private lazy var recommendCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.allowsMultipleSelection = false
        $0.delegate = self
        $0.dataSource = self
    }
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.delegate = self
        vc.dataSource = self
        return vc
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setSubviews()
        setLayout()
        registerCells()
        setFirstIndexSelected()
    }
    
    private func didTapCell(at indexPath: IndexPath) {
        currentPage = indexPath.item
    }
    
    private func bind(newValue: Int) {
        recommendCollectionView.selectItem(at: IndexPath(item: currentPage, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func setFirstIndexSelected() {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        recommendCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .bottom)
        
        if let recommendedVC = dataViewControllers.first {
            pageViewController.setViewControllers([recommendedVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - UI & Layout

extension RecommendVC {
    
    private func registerCells() {
        recommendCollectionView.register(RecommendCVC.self, forCellWithReuseIdentifier: RecommendCVC.className)
    }
    
    private func setUI() {
        headerUnderlineView.backgroundColor = .peekaRed
        self.view.backgroundColor = .peekaBeige
        recommendCollectionView.backgroundColor = .clear
    }
    
    private func setSubviews() {
        view.addSubviews([
            headerView,
            recommendCollectionView,
            pageViewController.view
        ])
        headerView.addSubviews([logoImage, headerUnderlineView])
    }
    
    private func setLayout() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        logoImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(18)
        }
        headerUnderlineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(recommendCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension RecommendVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCVC.className, for: indexPath) as? RecommendCVC else { return UICollectionViewCell() }
        cell.dataBind(menuLabel: recommendTypes[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            pageViewController.setViewControllers([recommendedVC], direction: .forward, animated: true, completion: nil)
        } else {
            pageViewController.setViewControllers([recommendingVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension RecommendVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return dataViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = dataViewControllers.firstIndex(of: currentVC) else { return }
        currentPage = currentIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == dataViewControllers.count {
            return nil
        }
        return dataViewControllers[nextIndex]
    }
}
