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
    
    private let searchContainerView = UIView()
    private lazy var searchButton = UIButton().then {
        $0.backgroundColor = .white.withAlphaComponent(0.4)
        $0.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    
    private let searchTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: I18N.BookSearch.bookSearch,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.peekaGray1])
        $0.backgroundColor = .white.withAlphaComponent(0.4)
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.addLeftPadding()
        $0.autocorrectionType = .no
        $0.becomeFirstResponder()
        $0.returnKeyType = .done
    }
    
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
        searchTextField.delegate = self
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
        searchContainerView.backgroundColor = .peekaWhite.withAlphaComponent(0.4)
        
        cancelButton.setImage(ImageLiterals.Icn.close, for: .normal)
        searchButton.setImage(ImageLiterals.Icn.search, for: .normal)
    }
    
    private func setLayout() {
        [headerView, searchContainerView].forEach {
            view.addSubview($0)
        }

        [cancelButton, headerTitleLabel, headerLineView].forEach {
            headerView.addSubview($0)
        }
        
        [searchTextField, searchButton].forEach {
            searchContainerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.width.height.equalTo(48)
        }
        
        headerTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        headerLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints { make in
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
            make.top.equalTo(searchContainerView.snp.bottom).offset(24)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
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
        bookTableView.register(BookInfoTVC.self,
                               forCellReuseIdentifier: BookInfoTVC.className)
    }
    
    func setView() {
        if self.bookInfoList.isEmpty == true || searchTextField.text!.isEmpty {
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
        guard searchTextField.hasText else {
            return setView()
        }
        searchTextField.endEditing(true)
        fetchBooks()
    }
    
    // MARK: - Server Helpers
    
    private func fetchBooks() {
        let ls = NaverSearchAPI.shared
        ls.getNaverBookTitleAPI(d_titl: searchTextField.text!, d_isbn: "", display: displayCount) { [weak self] result in
            if let result = result {
                self?.bookInfoList = result
                print(result)
                DispatchQueue.main.async {
                    self?.bookTableView.reloadData()
                    guard (self!.searchTextField.text?.isEmpty) == nil else {
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
            fetchBooks()
        }
    }
}

extension BookSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = searchTextField.text else { return true }
        if text.isEmpty {
            setView()
            searchTextField.endEditing(true)
            return true
        } else {
            fetchBooks()
            searchTextField.endEditing(true)
            return true
        }
    }
}
