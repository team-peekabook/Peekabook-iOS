//
//  DeclareVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/03/21.
//

import UIKit

import SnapKit
import Then

import Moya

final class DeclareVC: UIViewController {

    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .oneLeftButton)
        .addMiddleLabel(title: I18N.Declare.title)
        .addUnderlineView()
    
    private let selectLabel = UILabel().then {
        $0.text = I18N.Declare.selectTitle
        $0.textColor = .peekaRed
        $0.font = .h3
    }
    
    private lazy var declareTableView = UITableView().then {
        $0.showsVerticalScrollIndicator = false
        $0.allowsSelection = false
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let bottomUnderLineView = UIView()
    
    private let declareArray: [String] = [
        I18N.Declare.reason1,
        I18N.Declare.reason2,
        I18N.Declare.reason3,
        I18N.Declare.reason4,
        I18N.Declare.reason5
    ]
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
        setLayout()
        register()
        addTapGesture()
    }
}

// MARK: - UI & Layout

extension DeclareVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        declareTableView.backgroundColor = .peekaBeige
        bottomUnderLineView.backgroundColor = .peekaGray1
    }
    
    private func setLayout() {
        view.addSubviews(naviBar, selectLabel, declareTableView, bottomUnderLineView)
        
        naviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        selectLabel.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(49)
            $0.leading.equalToSuperview().offset(20)
        }
        
        declareTableView.snp.makeConstraints {
            $0.top.equalTo(selectLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(260)
        }
        
        bottomUnderLineView.snp.makeConstraints {
            $0.top.equalTo(declareTableView.snp.bottom)
            $0.leading.trailing.equalToSuperview().offset(20)
            $0.height.equalTo(0.5)
        }
    }
}

// MARK: - Methods

extension DeclareVC {
    private func register() {
        declareTableView.register(DeclareTableViewCell.self, forCellReuseIdentifier: DeclareTableViewCell.className)
    }
}

extension DeclareVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return declareArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeclareTableViewCell.className, for: indexPath) as? DeclareTableViewCell
        else {
            return UITableViewCell()
        }
        cell.label.text = declareArray[safe: indexPath.row]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row+1)
    }
}
