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
    var personName: String = ""
    var personId: Int = 0
    var bookShelfType: BookShelfType = .user
    var bookInfoList: [BookInfoModel] = []
    var displayCount: Int = 10
    
    // MARK: - UI Components
    
    private let headerView = UIView()
    private let containerView = UIView()
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
        $0.autocorrectionType = .no
    }
    
    lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        let backgroundView = UIView()
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
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
//        searchField.delegate = self
        setUI()
        setLayout()
        register()
        setTableViewLayout()
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
        containerView.addSubview(bookTableView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(128 * bookInfoList.count)
        }
    }
    
    func reLayout() {
        bookTableView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(128 * bookInfoList.count)
        }
    }
    private func register() {
        bookTableView.register(BookInfoTableViewCell.self,
                               forCellReuseIdentifier: BookInfoTableViewCell.identifier)
    }
    
    func setView() {
        if self.bookInfoList.isEmpty == true || searchField.text!.isEmpty { // 아무 값이 없으면
            self.emptyView.isHidden = false // 히든뷰가 보이게
            self.bookTableView.isHidden = true
        } else {
            self.bookTableView.isHidden = false
            self.emptyView.isHidden = true // 테이블뷰 보이게
        }
    }
    
    // MARK: - @objc Function
    
    @objc
    private func cancelButtonDidTap() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func bookBind(image: String, title: String, author: String) {
        bookInfoList.append(BookInfoModel(image: image, title: title, author: author))
    }
    
    @objc
    private func searchButtonDidTap() {
        guard searchField.hasText else {
            return setView()
        }
        searchField.endEditing(true)
        fetchBooks()
    }
    
    // MARK: - Server Helpers
    
    private func fetchBooks() {
        let ls = NaverSearchAPI.shared
        ls.getNaverBookTitleAPI(d_titl: searchField.text!, d_isbn: "", display: displayCount) { [weak self] result in
            if let result = result {
                self?.bookInfoList = result
                DispatchQueue.main.async {
                    self?.bookTableView.reloadData()
                    guard (self!.searchField.text?.isEmpty) == nil else {
                        return self!.setView()
                    }
                    self?.bookTableView.reloadData()
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch bookShelfType {
        case .user:
            let addBookVC = AddBookVC()
            addBookVC.modalPresentationStyle = .fullScreen
            addBookVC.dataBind(model: bookInfoList[indexPath.row])
            present(addBookVC, animated: true, completion: nil)
        case .friend:
            let proposalVC = ProposalVC()
            proposalVC.personName = personName
            proposalVC.personId = personId
            proposalVC.modalPresentationStyle = .fullScreen
            proposalVC.dataBind(model: bookInfoList[indexPath.row])
            present(proposalVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookCell = tableView.dequeueReusableCell(
            withIdentifier: BookInfoTableViewCell.identifier,
            for: indexPath) as? BookInfoTableViewCell
        else { return UITableViewCell() }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.peekaBeige
        bookCell.selectedBackgroundView = backgroundView
        
        bookCell.dataBind(model: bookInfoList[indexPath.row])
        return bookCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == scrollView.frame.height - 20 {
            displayCount += 10
            fetchBooks()
        }
    }
}

extension BookSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
}
