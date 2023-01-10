//
//  BookSearchVC.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/05.
//

import UIKit

import SnapKit
import Then

import Moya

final class BookSearchVC: UIViewController {
    
    // MARK: - Properties

    // MARK: - UI Components
    
    private let headerView = UIView()
    private let containerView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var cancelButton = UIButton().then {
        $0.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    private var headerTitleLabel = UILabel().then {
        $0.text = I18N.BookSearch.title
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private let headerLineView = UIView()
    
    private lazy var searchButton = UIButton().then {
        $0.backgroundColor = .white.withAlphaComponent(0.4)
        $0.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var searchField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: I18N.BookSearch.bookSearch,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.peekaGray1])
        $0.backgroundColor = .white.withAlphaComponent(0.4)
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.addLeftPadding()
    }
    
    private lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        }()
    
    private var bookInfoList: [BookInfoModel] = []

    // emptyView elements
    
    let emptyView = UIView()
    private let emptyImgView = UIImageView().then {
        $0.image = ImageLiterals.Icn.empty
    }
    
    private let emptyLabel = UILabel().then {
        $0.font = .h2
        $0.text = I18N.BookSearch.empty
        $0.textColor = .peekaRed_60
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyView.isHidden = true
        setUI()
        setLayout()
        register()
    }
}

// MARK: - UI & Layout
extension BookSearchVC {
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        headerLineView.backgroundColor = .peekaRed
        emptyView.backgroundColor = .clear
        
        cancelButton.setImage(ImageLiterals.Icn.close, for: .normal)
        searchButton.setImage(ImageLiterals.Icn.search, for: .normal)
    }
    
    private func setLayout() {
        view.addSubview(headerView)
        
        [cancelButton, headerTitleLabel, searchField, searchButton, headerLineView].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(110)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(2)
            make.trailing.equalToSuperview().inset(11)
            make.width.height.equalTo(48)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(cancelButton)
        }
        
        headerLineView.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.top)
            make.trailing.equalTo(headerLineView)
            make.width.height.equalTo(40)
        }
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(headerLineView.snp.bottom).offset(16)
            make.leading.equalTo(headerLineView)
            make.trailing.equalTo(searchButton.snp.leading)
            make.height.equalTo(40)
        }
        
        // emptyView Layout
        
        view.addSubview(emptyView)
        [emptyImgView, emptyLabel].forEach {
            emptyView.addSubview($0)
        }
        
        emptyView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(247)
            make.height.equalTo(96)
        }
        
        emptyImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImgView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setTableViewLayout() {
        view.addSubview(containerView)
        [bookTableView].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(128 * bookInfoList.count)
        }
    }
    
    private func register() {
        bookTableView.register(BookInfoTableViewCell.self,
            forCellReuseIdentifier: BookInfoTableViewCell.identifier)
    }
    
    private func setView() {
        if self.bookInfoList.isEmpty == true { // 아무 값이 없으면
            self.emptyView.isHidden = false // 히든뷰가 보이게
        } else {
            setTableViewLayout()
            self.emptyView.isHidden = true // 테이블뷰 보이게
        }
    }
    
    // MARK: - @objc Function
    
    @objc
    private func cancelButtonDidTap() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func searchButtonDidTap() {
        let ls = NaverSearchAPI()
        ls.getNaverBookAPI(d_titl: "아무튼")

//        getNaverBookAPI(String: searchField.text)
//        dataManager.shared.searchResult?.BookDetailList
//        bookInfoList.append(BookInfoModel(image: "bookSample3", title: "아무튼, 여름", author: "김신회"))
//        print(bookInfoList[0])
//        setView()
    }
}

// MARK: - Methods

extension BookSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}

extension BookSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookCell = tableView.dequeueReusableCell(
            withIdentifier: BookInfoTableViewCell.identifier,
            for: indexPath) as? BookInfoTableViewCell
        else { return UITableViewCell() }

        bookCell.dataBind(model: bookInfoList[indexPath.row])
        return bookCell
    }
}
