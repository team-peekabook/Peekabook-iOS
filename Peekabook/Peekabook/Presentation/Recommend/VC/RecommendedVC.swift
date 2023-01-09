//
//  RecommendedVC.swift
//  Peekabook
//
//  Created by 김인영 on 2023/01/03.
//

import UIKit

class RecommendedVC: UIViewController {
    
    // MARK: - Properties
    
    private var recommendedDummy: [RecommendModel] = [
        RecommendModel(
            image: ImageLiterals.Sample.book1,
            bookName: "아무튼, 여름",
            writer: "김신회",
            recommendedPersonImage: ImageLiterals.Sample.profile3,
            recommendedPerson: "김인영",
            memo: "‘추천사요약’ 을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. 당신에게 추천해요!"
        ),
        RecommendModel(
            image: ImageLiterals.Sample.book1,
            bookName: "아무튼, 여름",
            writer: "김신회",
            recommendedPersonImage: ImageLiterals.Sample.profile3,
            recommendedPerson: "윤수빈",
            memo: "‘추천사요약’ 을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. 당신에게 추천해요! ‘추천사요약’을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. ‘추천사요약’을 쓸 건데 나는 이 책이 상당한 지식을 얻을 수 있는 기회를 제공한다고 생각합니다. ‘추천사요약’을 쓸 건데 나는 이 책이 후"
        ),
        RecommendModel(
            image: ImageLiterals.Sample.book1,
            bookName: "아무튼, 여름",
            writer: "김신회",
            recommendedPersonImage: ImageLiterals.Sample.profile3,
            recommendedPerson: "김인영",
            memo: ""
        )
    ]
    
    // MARK: - UI Components
    
    private lazy var tableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.allowsSelection = false
        $0.allowsMultipleSelection = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        registerCells()
    }
}

// MARK: - UI & Layout

extension RecommendedVC {
    private func registerCells() {
        tableView.register(
            RecommendTVC.self,
            forCellReuseIdentifier: RecommendTVC.className
        )
    }
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        tableView.backgroundColor = .peekaBeige
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

extension RecommendedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 221
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return recommendedDummy.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecommendTVC.className,
            for: indexPath
        ) as? RecommendTVC
        else {
            return UITableViewCell()
        }
        cell.dataBind(model: recommendedDummy[indexPath.item])
        return cell
    }
}
