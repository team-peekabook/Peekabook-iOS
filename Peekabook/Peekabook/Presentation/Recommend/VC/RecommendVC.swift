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

    private var recommendTypes: [String] = [I18N.BookRecommend.recommended, I18N.BookRecommend.recommending]
    
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
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .changeLeftBackButtonToLogoImage()
        .addUnderlineView()
    
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumInteritemSpacing = 17
        $0.sectionInset = UIEdgeInsets(
            top: 16,
            left: 22,
            bottom: 17,
            right: 22
        )
    }
    private lazy var recommendCollectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.allowsMultipleSelection = false
    }
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        return vc
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        addSubviews()
        setLayout()
        setDelegate()
        registerCells()
        setFirstIndexSelected()
    }
}

// MARK: - UI & Layout

extension RecommendVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        recommendCollectionView.backgroundColor = .clear
    }
    
    private func addSubviews() {
        view.addSubviews(
            naviBar,
            recommendCollectionView
        )
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setLayout() {
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        recommendCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(63)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(recommendCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension RecommendVC {
    
    private func registerCells() {
        recommendCollectionView.register(
            RecommendTypeCVC.self,
            forCellWithReuseIdentifier: RecommendTypeCVC.className
        )
    }
    
    private func setDelegate() {
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    private func didTapCell(at indexPath: IndexPath) {
        currentPage = indexPath.item
    }
    
    private func bind(newValue: Int) {
        recommendCollectionView.selectItem(
            at: IndexPath(
                item: currentPage,
                section: 0),
            animated: true,
            scrollPosition: .centeredHorizontally
        )
    }
    
    private func setFirstIndexSelected() {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        recommendCollectionView.selectItem(
            at: selectedIndexPath,
            animated: true,
            scrollPosition: .bottom
        )
        
        if let recommendedVC = dataViewControllers.first as? RecommendedVC {
            recommendedVC.viewWillAppear(true)
        } else {
            recommendingVC.viewWillAppear(true)
        }
        
        pageViewController.setViewControllers(
            [dataViewControllers[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension RecommendVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendTypeCVC.className, for: indexPath) as? RecommendTypeCVC else { return UICollectionViewCell() }
        cell.dataBind(menuLabel: recommendTypes[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pageViewController.setViewControllers(
            [dataViewControllers[indexPath.item]],
            direction: indexPath.row == 0 ? .reverse : .forward,
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource

extension RecommendVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
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
        if nextIndex == dataViewControllers.count { return nil }
        return dataViewControllers[nextIndex]
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct RecommendVCPreview: PreviewProvider {
    static var previews: some View {
        RecommendVC().toPreview()
    }
}
#endif
