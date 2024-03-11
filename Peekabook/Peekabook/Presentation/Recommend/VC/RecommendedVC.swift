//
//  RecommendedVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

final class RecommendedVC: UIViewController {
    
    // MARK: - Properties
    
    var isEditingMode: Bool = false {
        didSet {
            // isEditingMode 속성 변경 시에도 적절히 처리
            updateCellsEditingMode(isEditingMode)
        }
    }

    private var recommendedBooks: [RecommendBook] = []
    
    // MARK: - UI Components
    
    private lazy var recommendedTableView = UITableView().then {
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
        label.text = I18N.BookRecommend.recommendedEmptyDescription
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setLayout()
        setDelegate()
        registerCells()
        getNotification()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecommendedBooksAPI()
    }
}

// MARK: - UI & Layout

extension RecommendedVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        recommendedTableView.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubviews(recommendedTableView, emptyDescriptionLabel)
        
        recommendedTableView.snp.makeConstraints {
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

extension RecommendedVC {
    
    private func registerCells() {
        recommendedTableView.register(
            RecommendListTVC.self,
            forCellReuseIdentifier: RecommendListTVC.className
        )
    }
    
    private func setDelegate() {
        recommendedTableView.delegate = self
        recommendedTableView.dataSource = self
    }
    
    func scrollToTop() {
        let contentOffset = CGPoint(x: 0, y: 0)
        self.recommendedTableView.setContentOffset(contentOffset, animated: true)
    }
    
    func updateCellsEditingMode(_ isEditing: Bool) {
        // TableView의 모든 셀의 Editing 모드를 업데이트
        for case let cell as RecommendListTVC in recommendedTableView.visibleCells {
            cell.checkEditing(isEditing)
            
        }
    }
    
    func getNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleImageTapped), name: NSNotification.Name(rawValue: "ImageTappedNotification"), object: nil)
    }
    
    @objc func handleImageTapped(_ notification: Notification) {
        if let userInfo = notification.userInfo,
               let recommendID = userInfo["recommendID"] as? Int {
                deleteRecommendedAPI(recommendId: recommendID)
            }
    }
}

extension RecommendedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendListTVC.className, for: indexPath) as? RecommendListTVC else { return UITableViewCell() }
        cell.dataBind(model: recommendedBooks[safe: indexPath.row]!)
        cell.checkEditing(self.isEditingMode)
        return cell
    }
}

// MARK: - Network

extension RecommendedVC {
    
    private func getRecommendedBooksAPI() {
        RecommendAPI(viewController: self).getRecommend { response in
            if response?.success == true {
                guard let serverGetRecommendedBook = response?.data else { return }
                self.recommendedBooks = serverGetRecommendedBook.recommendedBook

                DispatchQueue.main.async {

                    if let recommendedBooks = response?.data?.recommendedBook, !recommendedBooks.isEmpty {
                        self.emptyDescriptionLabel.isHidden = true
                        self.recommendedTableView.isHidden = false
                    } else {
                        self.emptyDescriptionLabel.isHidden = false
                        self.recommendedTableView.isHidden = true
                    }

                    self.recommendedTableView.reloadData()
                }
                
            }
        }
    }
    
    private func deleteRecommendedAPI(recommendId: Int) {
        RecommendAPI(viewController: self).deleteRecommend(recommendId: recommendId) { response in
            print(response)
            if response?.success == true {
                if let index = self.recommendedBooks.firstIndex(where: { $0.recommendID == recommendId }) {
                    self.recommendedBooks.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.recommendedTableView.deleteRows(at: [indexPath], with: .left)
                    self.recommendedTableView.reloadData()
                }
            }
        }
    }
}
