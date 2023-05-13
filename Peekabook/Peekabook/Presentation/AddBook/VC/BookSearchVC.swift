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
    
    private var serverNaverSearch: [BookInfoModel]?
    
    var searchType: SearchType = .text
    var personName: String = ""
    var personId: Int = 0
    
    var bookShelfType: BookShelfType = .user
    var bookInfoList: [BookInfoModel] = []
    var displayCount: Int = 30
    
    // MARK: - UI Components
    
    private lazy var headerView = CustomNavigationBar(self, type: .oneRightButton)
        .addMiddleLabel(title: I18N.BookSearch.title)
        .addRightButtonAction {
            self.cancelButtonDidTap()
        }
        .addUnderlineView()
    private let containerView = UIView()
    private lazy var bookSearchView = CustomSearchView(frame: .zero, type: .bookSearch, viewController: self)
    
    private lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        let backgroundView = UIView()
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // emptyView elements
    
    private let emptyView = UIView()
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
        bookSearchView.setSearchTextFieldDelegate(self)
        setBackgroundColor()
        setLayout()
        register()
        setTableViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookSearchView.showKeyboard()
    }
}

// MARK: - UI & Layout
extension BookSearchVC {
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        
        headerView.backgroundColor = .clear
        emptyView.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(headerView, bookSearchView)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookSearchView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        // emptyView Layout
        
        view.addSubview(emptyView)
        emptyView.addSubviews(emptyImgView, emptyLabel)
        
        emptyView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(247)
            $0.height.equalTo(96)
        }
        
        emptyImgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImgView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setTableViewLayout() {
        view.addSubview(containerView)
        containerView.addSubview(bookTableView)
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(bookSearchView.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func register() {
        bookTableView.register(BookInfoTVC.self,
                               forCellReuseIdentifier: BookInfoTVC.className)
    }
    
    func setView() {
        if self.bookInfoList.isEmpty == true || bookSearchView.text!.isEmpty {
            self.emptyView.isHidden = false
            self.bookTableView.isHidden = true
        } else {
            self.bookTableView.isHidden = false
            self.emptyView.isHidden = true
        }
    }
    
    // MARK: - @objc Function
    
    @objc
    private func cancelButtonDidTap() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func bookBind(image: String, title: String, author: String, publisher: String) {
        bookInfoList.append(BookInfoModel(title: title, image: image, author: author, publisher: publisher))
    }
    
    @objc
    func searchButtonDidTap() {
        guard bookSearchView.hasSearchText() else {
            return setView()
        }
        bookSearchView.endEditing()
        if let searchText = bookSearchView.text {
            getNaverSearchData(d_titl: searchText, d_isbn: "", display: displayCount)
        }
    }
}

// MARK: - Methods

extension BookSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
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
            addBookVC.dataBind(model: bookInfoList[safe: indexPath.row]!)
            present(addBookVC, animated: true, completion: nil)
        case .friend:
            let proposalVC = ProposalVC()
            proposalVC.personName = personName
            proposalVC.personId = personId
            proposalVC.author = bookInfoList[safe: indexPath.row]!.author
            proposalVC.bookTitle = bookInfoList[safe: indexPath.row]!.title
            proposalVC.imageUrl = bookInfoList[safe: indexPath.row]!.image
            proposalVC.modalPresentationStyle = .fullScreen
            proposalVC.dataBind(model: bookInfoList[safe: indexPath.row]!)
            present(proposalVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookCell = tableView.dequeueReusableCell(
            withIdentifier: BookInfoTVC.className,
            for: indexPath) as? BookInfoTVC
        else { return UITableViewCell() }
        
        bookCell.bookShelfType = self.bookShelfType
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.peekaBeige
        bookCell.selectedBackgroundView = backgroundView
        
        bookCell.dataBind(model: bookInfoList[safe: indexPath.row]!, bookShelfType: bookShelfType)
        
        if !bookInfoList.isEmpty {
            self.bookTableView.isHidden = false
        }
        self.setView()
        
        return bookCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        let scrollViewOffset = scrollView.contentOffset.y
        if scrollViewOffset + scrollViewHeight == scrollViewContentHeight {
            displayCount += 10
            if let searchText = bookSearchView.text {
                getNaverSearchData(d_titl: searchText, d_isbn: "", display: displayCount)
            }
        }
    }
}

extension BookSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonDidTap()
        bookSearchView.endEditing()
        return true
    }
}

extension BookSearchVC {
    
    private func getNaverSearchData(d_titl: String, d_isbn: String, display: Int) {
        NaverSearchAPI.shared.getNaverSearchedBooks(d_titl: d_titl, d_isbn: d_isbn, display: display) { response in
            self.bookInfoList = []
            
            guard let response = response else { return }
            
            for i in 0..<response.count {
                self.bookInfoList.append(BookInfoModel(title: response[i].title, image: response[i].image, author: response[i].author, publisher: response[i].publisher))
            }
            
            DispatchQueue.main.async {
                self.bookTableView.reloadData()
                if let searchText = self.bookSearchView.text, !searchText.isEmpty, self.bookInfoList.isEmpty == false {
                    self.bookTableView.reloadData()
                } else {
                    self.setView()
                }
            }
        }
    }
}
