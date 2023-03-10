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
    
    private let headerView = UIView()
    private let containerView = UIView()
    private lazy var cancelButton = UIButton().then {
        $0.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        $0.setImage(ImageLiterals.Icn.close, for: .normal)
    }
    
    private let headerTitleLabel = UILabel().then {
        $0.text = I18N.BookSearch.title
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private let headerLineView = UIView()
    private let bookSearchView = CustomSearchView()
    
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
        setCustomView()
        setDelegate()
        setBackgroundColor()
        setLayout()
        register()
        setTableViewLayout()
    }
}

// MARK: - UI & Layout
extension BookSearchVC {
    
    private func setCustomView() {
        bookSearchView.getSearchButton().addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    
    private func setDelegate() {
        bookSearchView.getSearchTextField().delegate = self
    }
    
    private func setBackgroundColor() {
        self.view.backgroundColor = .peekaBeige
        
        headerView.backgroundColor = .clear
        headerLineView.backgroundColor = .peekaRed
        emptyView.backgroundColor = .clear
    }
    
    private func setLayout() {
        [headerView, bookSearchView].forEach {
            view.addSubview($0)
        }

        [cancelButton, headerTitleLabel, headerLineView].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(8)
            $0.width.height.equalTo(48)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        headerLineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        bookSearchView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        // emptyView Layout
        
        view.addSubview(emptyView)
        [emptyImgView, emptyLabel].forEach {
            emptyView.addSubview($0)
        }
        
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
        if self.bookInfoList.isEmpty == true || bookSearchView.getSearchTextField().text!.isEmpty {
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
    private func searchButtonDidTap() {
        guard bookSearchView.getSearchTextField().hasText else {
            return setView()
        }
        bookSearchView.getSearchTextField().endEditing(true)
        getNaverSearchData(d_titl: bookSearchView.getSearchTextField().text!, d_isbn: "", display: displayCount)
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
            getNaverSearchData(d_titl: bookSearchView.getSearchTextField().text!, d_isbn: "", display: displayCount)
        }
    }
}

extension BookSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = bookSearchView.getSearchTextField().text else { return true }
        if text.isEmpty {
            setView()
            bookSearchView.getSearchTextField().endEditing(true)
            return true
        } else {
            getNaverSearchData(d_titl: bookSearchView.getSearchTextField().text!, d_isbn: "", display: displayCount)
            bookSearchView.getSearchTextField().endEditing(true)
            return true
        }
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
                if let searchText = self.bookSearchView.getSearchTextField().text, !searchText.isEmpty, self.bookInfoList.isEmpty == false {
                    self.bookTableView.reloadData()
                } else {
                    self.setView()
                }
            }
        }
    }
}
