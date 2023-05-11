//
//  RecommendingVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

final class RecommendingVC: UIViewController {
    
    // MARK: - Properties
    
    private var serverGetRecommendingBook: GetRecommendResponse?
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
}

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
        cell.dataBind(model: recommendingBooks[safe: indexPath.row]!)
        return cell
    }
}

// MARK: - Network

extension RecommendingVC {
    
    private func getRecommendingBooksAPI() {
        RecommendAPI.shared.getRecommend { response in
            if response?.success == true {
                guard let serverGetRecommendingBook = response?.data else { return }
                self.recommendingBooks = serverGetRecommendingBook.recommendingBook
                self.recommendingTableView.reloadData()
                
                // TODO: - 엠티뷰
                if response?.data?.recommendingBook.isEmpty == true {
                    self.emptyDescriptionLabel.isHidden = false
                    self.recommendingTableView.isHidden = true
                } else {
                    self.emptyDescriptionLabel.isHidden = true
                    self.recommendingTableView.isHidden = false
                }
            }
        }
    }
}
