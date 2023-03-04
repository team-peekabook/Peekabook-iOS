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
    
    private var serverNaverSearch: [Item]?
    
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
    }
    
    private let headerTitleLabel = UILabel().then {
        $0.text = I18N.BookSearch.title
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private let headerLineView = UIView()
    private let bookSearchView = CustomSearchView()
    
    lazy var bookTableView: UITableView = {
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
        setReusableView()
        setDelegate()
        setUI()
        setLayout()
        register()
        setTableViewLayout()
    }
}

// MARK: - UI & Layout
extension BookSearchVC {
    
    private func setReusableView() {
        bookSearchView.searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    
    private func setDelegate() {
        bookSearchView.searchTextField.delegate = self
    }
    
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        headerLineView.backgroundColor = .peekaRed
        emptyView.backgroundColor = .clear
        cancelButton.setImage(ImageLiterals.Icn.close, for: .normal)
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
            $0.top.equalTo(bookSearchView.searchContainerView.snp.bottom).offset(24)
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
        if self.bookInfoList.isEmpty == true || bookSearchView.searchTextField.text!.isEmpty {
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
    
    func bookBind(image: String, title: String, author: String) {
        bookInfoList.append(BookInfoModel(image: image, title: title, author: author))
    }
    
    @objc
    private func searchButtonDidTap() {
        guard bookSearchView.searchTextField.hasText else {
            return setView()
        }
        bookSearchView.searchTextField.endEditing(true)
        getNaverSearchData(d_titl: bookSearchView.searchTextField.text!, d_isbn: "", display: displayCount)
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
            addBookVC.dataBind(model: bookInfoList[indexPath.row])
            present(addBookVC, animated: true, completion: nil)
        case .friend:
            let proposalVC = ProposalVC()
            proposalVC.personName = personName
            proposalVC.personId = personId
            proposalVC.author = bookInfoList[indexPath.row].author
            proposalVC.bookTitle = bookInfoList[indexPath.row].title
            proposalVC.imageUrl = bookInfoList[indexPath.row].image
            proposalVC.modalPresentationStyle = .fullScreen
            proposalVC.dataBind(model: bookInfoList[indexPath.row])
            present(proposalVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bookCell = tableView.dequeueReusableCell(
            withIdentifier: BookInfoTVC.className,
            for: indexPath) as? BookInfoTVC
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
            getNaverSearchData(d_titl: bookSearchView.searchTextField.text!, d_isbn: "", display: displayCount)
        }
    }
}

extension BookSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = bookSearchView.searchTextField.text else { return true }
        if text.isEmpty {
            setView()
            bookSearchView.searchTextField.endEditing(true)
            return true
        } else {
            getNaverSearchData(d_titl: bookSearchView.searchTextField.text!, d_isbn: "", display: displayCount)
            bookSearchView.searchTextField.endEditing(true)
            return true
        }
    }
}

extension BookSearchVC {
    
    func getNaverSearchData(d_titl: String, d_isbn: String, display: Int) {
        NaverSearchAPI.shared.getNaverSearchData(d_titl: d_titl, d_isbn: d_isbn, display: display) { response in
            self.bookInfoList = []
            
            guard let response = response else { return }
            
            for i in 0..<response.count {
                self.bookInfoList.append(BookInfoModel(image: response[i].image, title: response[i].title, author: response[i].author))
            }
            
            DispatchQueue.main.async {
                self.bookTableView.reloadData()
                guard (self.bookSearchView.searchTextField.text?.isEmpty) == nil else {
                    return self.setView()
                }
                self.bookTableView.reloadData()
            }
        }
    }
}
