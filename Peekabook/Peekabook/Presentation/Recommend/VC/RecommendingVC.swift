//
//  RecommendingVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

final class RecommendingVC: UIViewController {
    
    // MARK: - Properties
    
    var isEditingMode: Bool = false {
        didSet {
            // isEditingMode 속성 변경 시에도 적절히 처리
            updateCellsEditingMode(isEditingMode)
        }
    }

    private var recommendingBooks: [RecommendBook] = []
    
    // MARK: - UI Components
    
    private lazy var recommendingTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.allowsSelection = false
        $0.allowsMultipleSelection = false
        $0.separatorStyle = .none
        $0.contentInset.bottom = 15
    }
    
    private let emptyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textAlignment = .center
        label.textColor = .peekaRed_60
        label.text = I18N.BookRecommend.recommendingEmptyDescription
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        registerCells()
        getNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecommendingBooksAPI()
    }
}

// MARK: - UI & Layout

extension RecommendingVC {
    
    private func setUI() {
        recommendingTableView.backgroundColor = .peekaBeige
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(recommendingTableView, emptyDescriptionLabel)

        recommendingTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

// MARK: - Methods

extension RecommendingVC {
    
    private func registerCells() {
        recommendingTableView.register(
            RecommendListTVC.self,
            forCellReuseIdentifier: RecommendListTVC.className
        )
    }
    
    private func setDelegate() {
        recommendingTableView.delegate = self
        recommendingTableView.dataSource = self
    }
    
    func scrollToTop() {
        let contentOffset = CGPoint(x: 0, y: 0)
        self.recommendingTableView.setContentOffset(contentOffset, animated: true)
    }
    
    func updateCellsEditingMode(_ isEditing: Bool) {
        // TableView의 모든 셀의 Editing 모드를 업데이트
        for case let cell as RecommendListTVC in recommendingTableView.visibleCells {
            cell.checkEditing(isEditing)
            
        }
    }
    
    func getNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(deleteImageTapped), name: NSNotification.Name(rawValue: "ImageTappedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recommendDeletedNotification), name: NSNotification.Name(rawValue: "RecommendDeletedNotification"), object: nil)
    }
    
    @objc func deleteImageTapped(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let recommendID = userInfo["recommendID"] as? Int {
            let deletePopUpVC = RecommendDeletePopUpVC()
            deletePopUpVC.recommendId = recommendID
            deletePopUpVC.modalPresentationStyle = .overFullScreen
            self.present(deletePopUpVC, animated: false)
        }
    }
    
    @objc func recommendDeletedNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let recommendId = userInfo["recommendID"] as? Int {
            if let index = recommendingBooks.firstIndex(where: { $0.recommendID == recommendId }) {
                recommendingBooks.remove(at: index)
                let indexPath = IndexPath(row: index, section: 0)
                recommendingTableView.deleteRows(at: [indexPath], with: .left)
                recommendingTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RecommendingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendingBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendListTVC.className, for: indexPath) as? RecommendListTVC
        else { return UITableViewCell() }
        
        cell.dataBind(model: recommendingBooks[indexPath.row])
        cell.checkEditing(self.isEditingMode)
        return cell
    }
}

// MARK: - Network

extension RecommendingVC {
    
    private func getRecommendingBooksAPI() {
        RecommendAPI(viewController: self).getRecommend { response in
            if response?.success == true {
                guard let serverGetRecommendingBook = response?.data else { return }
                self.recommendingBooks = serverGetRecommendingBook.recommendingBook
                
                DispatchQueue.main.async {
                    if let recommendingBooks = response?.data?.recommendingBook, !recommendingBooks.isEmpty {
                        self.emptyDescriptionLabel.isHidden = true
                        self.recommendingTableView.isHidden = false
                    } else {
                        self.emptyDescriptionLabel.isHidden = false
                        self.recommendingTableView.isHidden = true
                    }
                    
                    self.recommendingTableView.reloadData()
                }

            }
        }
    }
}
