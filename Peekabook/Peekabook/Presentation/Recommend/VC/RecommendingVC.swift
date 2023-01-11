//
//  RecommendingVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

class RecommendingVC: UIViewController {
    
    // MARK: - Properties
    
    private var serverGetRecommendingBook: GetRecommendResponse?
    private var recommendingBooks: [RecommendBook] = []
    
    // MARK: - UI Components
    
    private lazy var tableView = UITableView().then {
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
        tableView.backgroundColor = .peekaBeige
        self.view.backgroundColor = .peekaBeige
    }
    
    private func setLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Methods

extension RecommendingVC {
    
    private func registerCells() {
        tableView.register(
            RecommendTVC.self,
            forCellReuseIdentifier: RecommendTVC.className
        )
    }
    
    private func setDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension RecommendingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendingBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendTVC.className, for: indexPath) as? RecommendTVC
        else { return UITableViewCell() }
        cell.dataBind(model: recommendingBooks[indexPath.row])
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
                self.tableView.reloadData()
            } else {
                print("false")
            }
        }
    }
}
