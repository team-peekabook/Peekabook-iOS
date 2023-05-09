//
//  RecommendedVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

final class RecommendedVC: UIViewController {
    
    // MARK: - Properties
    
    private var serverGetRecommendedBook: GetRecommendResponse?
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
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setLayout()
        setDelegate()
        registerCells()
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
        view.addSubview(recommendedTableView)
        
        recommendedTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
        return cell
    }
}

// MARK: - Network

extension RecommendedVC {
    
    private func getRecommendedBooksAPI() {
        RecommendAPI.shared.getRecommend { response in
            if response?.success == true {
                guard let serverGetRecommendedBook = response?.data else { return }
                self.recommendedBooks = serverGetRecommendedBook.recommendedBook
                self.recommendedTableView.reloadData()
            }
        }
    }
}
