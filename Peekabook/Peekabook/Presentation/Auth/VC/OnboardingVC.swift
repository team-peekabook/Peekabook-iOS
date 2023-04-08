//
//  OnboardingVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/04/07.
//

import UIKit

final class OnboardingVC: UIViewController {
    
    // MARK: - Properties

    private var onboardingData = [OnboardingDataModel]()
    
    private var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    // MARK: - UI Components
        
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiterals.Onboarding.background
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private lazy var onboardingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .peekaGray1
        pc.currentPageIndicatorTintColor = .peekaRed
        pc.numberOfPages = 4
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    private lazy var startButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.titleLabel!.font = .nameBold
        bt.setTitle(I18N.Onboarding.startButton, for: .normal)
        bt.setTitleColor(.peekaWhite, for: .normal)
        bt.backgroundColor = .peekaRed
        bt.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        return bt
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setCollectionViewCell()
        setOnboardingData()
    }
}

// MARK: - UI & Layout

extension OnboardingVC {
    
    private func setLayout() {
        view.addSubviews(backgroundImageView, onboardingCollectionView, startButton, pageControl)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
                
        onboardingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(620.adjustedH)
        }
        
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20.adjustedH)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(56.adjustedH)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(startButton).offset(-40.adjustedH)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension OnboardingVC {
    
    @objc
    private func startButtonDidTap() {
        self.switchRootViewController(rootViewController: LoginVC(), animated: true, completion: nil)
    }
    
    private func setCollectionViewCell() {
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        
        onboardingCollectionView.register(OnboardingCVC.self, forCellWithReuseIdentifier: OnboardingCVC.className)
    }
    
    private func setOnboardingData() {
        onboardingData.append(contentsOf: [
            OnboardingDataModel(image: ImageLiterals.Onboarding.first!,
                                title: I18N.Onboarding.first),
            OnboardingDataModel(image: ImageLiterals.Onboarding.second!,
                                title: I18N.Onboarding.second),
            OnboardingDataModel(image: ImageLiterals.Onboarding.third!,
                                title: I18N.Onboarding.third),
            OnboardingDataModel(image: ImageLiterals.Onboarding.fourth!,
                                title: I18N.Onboarding.fourth)
        ])
    }
}

// MARK: - CollectionView Delegate, DataSource

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = onboardingCollectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCVC.className, for: indexPath) as? OnboardingCVC else { return UICollectionViewCell() }
        cell.setOnboardingSlides(onboardingData[indexPath.row])
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.view.frame.width)
        self.currentPage = page
    }
}

// MARK: - CollectionView DelegateFlowLayout

extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = self.view.frame.size.width
        return CGSize(width: length, height: 620.adjustedH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
