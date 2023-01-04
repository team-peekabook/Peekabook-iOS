//
//  BottomBookShelfVC.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

final class BottomBookShelfVC: UIViewController {
    
    // MARK: - Properties
    
    private var pickModelList = SampleBookModel.data
    private let fullView: CGFloat = 50
    private var partialView: CGFloat = UIScreen.main.bounds.height - 200

    // MARK: - UI Components
    
    private let headerContainerView = UIView()
    
    private let booksCountLabel = UILabel().then {
        $0.text = "10 Books"
        $0.font = .engSb
        $0.textColor = .peekaRed
    }
    
    private lazy var addBookButton = UIButton(type: .system).then {
        $0.setImage(ImageLiterals.Icn.addBook, for: .normal)
        $0.addTarget(self, action: #selector(addBookButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var bookShelfCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 50, right: 20)
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
        regeisterPanGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - @objc Function
    @objc
    private func addBookButtonDidTap() {
        let addBookVC = AddBookVC()
        navigationController?.pushViewController(addBookVC, animated: true)
    }
    
    @objc
    private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
            }, completion: nil)
        }
    }
}

// MARK: - UI & Layout
extension BottomBookShelfVC {
    
    private func setUI() {
        view.backgroundColor = .peekaBeige
        headerContainerView.backgroundColor = .peekaLightBeige
        bookShelfCollectionView.backgroundColor = .peekaLightBeige
        roundViews()
    }
    
    private func setLayout() {
        view.addSubviews(headerContainerView, bookShelfCollectionView)
        headerContainerView.addSubviews(booksCountLabel, addBookButton)
        
        headerContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        booksCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        addBookButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
        
        bookShelfCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension BottomBookShelfVC {
    
    private func regeisterPanGesture() {
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomBookShelfVC.panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    private func setDelegate() {
        bookShelfCollectionView.delegate = self
        bookShelfCollectionView.dataSource = self
    }
    
    private func registerCells() {
        bookShelfCollectionView.register(BookShelfCVC.self, forCellWithReuseIdentifier: BookShelfCVC.className)
    }
    
    private func animateView() {
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    private func roundViews() {
        self.view.layer.cornerRadius = 15
        view.clipsToBounds = true
    }
    
    private func prepareBackgroundView() {
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BottomBookShelfVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickModelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookShelfCVC.className, for: indexPath)
                as? BookShelfCVC else { return UICollectionViewCell() }
        cell.initCell(model: pickModelList[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout

extension BottomBookShelfVC: UICollectionViewDelegateFlowLayout {
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
