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
import SafariServices

final class BookSearchVC: UIViewController, CustomSearchViewDelegate {
    
    // MARK: - Properties
    
    private var serverNaverSearch: [BookInfoModel]?
    private var isLastPage: Bool = false
    
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
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var footerButtonView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        let button = UIButton(type: .system)
        let lineView = UIView()
        lineView.backgroundColor = .peekaRed
        
        footer.addSubview(button)
        footer.addSubview(lineView)
        
        button.setTitle(I18N.BookSearch.notFound, for: .normal)
        button.setTitleColor(.peekaRed, for: .normal)
        button.titleLabel?.font = .c2
        button.addTarget(self, action: #selector(footerButtonDidTap), for: .touchUpInside)
        footer.addSubview(button)
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(-6)
            $0.centerX.equalTo(button)
            $0.width.equalTo(button)
            $0.height.equalTo(1)
        }
        
        return footer
    }()
    
    private lazy var fixedFooterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(I18N.BookSearch.notFound, for: .normal)
        button.setTitleColor(.peekaRed, for: .normal)
        button.titleLabel?.font = .c2
        button.addTarget(self, action: #selector(footerButtonDidTap), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private let fixedFooterLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .peekaRed
        view.isHidden = true
        return view
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
        bookSearchView.delegate = self
        bookSearchView.setSearchTextFieldDelegate(self)
        bookTableView.tableFooterView = UIView(frame: .zero)
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
        view.addSubviews(headerView, bookSearchView, fixedFooterButton, fixedFooterLineView)
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        bookSearchView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        fixedFooterButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(59)
        }

        fixedFooterLineView.snp.makeConstraints {
            $0.top.equalTo(fixedFooterButton.snp.bottom).offset(-6)
            $0.centerX.equalTo(fixedFooterButton)
            $0.width.equalTo(fixedFooterButton)
            $0.height.equalTo(1)
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
    
}

// MARK: - Methods

extension BookSearchVC {
    
    private func register() {
        bookTableView.register(BookInfoTVC.self,
                               forCellReuseIdentifier: BookInfoTVC.className)
    }
    
    func setView() {
        if self.bookInfoList.isEmpty || bookSearchView.text!.isEmpty {
            emptyView.isHidden = false
            bookTableView.isHidden = true
            fixedFooterButton.isHidden = true
        } else {
            emptyView.isHidden = true
            bookTableView.isHidden = false
            
            if bookInfoList.count >= 1 && bookInfoList.count <= 3 {
                fixedFooterButton.isHidden = false
                fixedFooterLineView.isHidden = false
            } else {
                fixedFooterButton.isHidden = true
                fixedFooterLineView.isHidden = true
            }
        }
    }
    
    func bookBind(image: String, title: String, author: String, publisher: String) {
        bookInfoList.append(BookInfoModel(title: title, image: image, author: author, publisher: publisher))
    }
    
    // MARK: - @objc Function
    
    @objc
    private func cancelButtonDidTap() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func ReturnDidTap() {
        guard bookSearchView.hasSearchText() else {
            return setView()
        }
        bookSearchView.endEditing()
        if let searchText = bookSearchView.text {
            getNaverSearchData(query: searchText, d_isbn: "", display: displayCount)
        }
    }
    
    @objc func footerButtonDidTap() {
        let safariViewController = SFSafariViewController(url: URL(string: ExternalURL.BookSearch.addNewBook)!)
        self.present(safariViewController, animated: true)
    }
    
    func barcodeButtonDidTap() {
        let barcodeVC = BarcodeVC()
        barcodeVC.modalPresentationStyle = .fullScreen
        self.present(barcodeVC, animated: true, completion: nil)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BookSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 138
    }
    
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
        case .friendFollowing, .friendNotFollowing:
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
        
        // 스크롤 끝까지 내려갔을 때
        if scrollViewOffset + scrollViewHeight >= scrollViewContentHeight - 10 {
            // 마지막 페이지일 때 footer 버튼
            if isLastPage {
                self.bookTableView.tableFooterView = UIView(frame: .zero) // footer 숨김
            } else {
                self.bookTableView.tableFooterView = self.footerButtonView // footer 보여줌
            }
        } else {
            // 스크롤 끝에 안도달 -> footer 숨김
            self.bookTableView.tableFooterView = UIView(frame: .zero)
        }
    }
}

// MARK: - UITextFieldDelegate

extension BookSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ReturnDidTap()
        bookSearchView.endEditing()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        bookSearchView.textDidChange(updatedText)
        return true
    }

}

// MARK: - Network

extension BookSearchVC {
    
    private func getNaverSearchData(query: String, d_isbn: String, display: Int) {
        NaverSearchAPI(viewController: self).getNaverSearchedBooks(query: query, d_isbn: d_isbn, display: display) { response in
            self.bookInfoList = []
            
            guard let response = response else { return }
            self.isLastPage = response.count < display
            
            for i in 0..<response.count {
                self.bookInfoList.append(BookInfoModel(title: response[i].title, image: response[i].image, author: response[i].author, publisher: response[i].publisher))
            }
            
            DispatchQueue.main.async {
                self.bookTableView.reloadData()
                self.setView()
                self.updateFooterView()
            }
                
        }
    }
    
    private func updateFooterView() {
        if isLastPage {
            let contentFitsScreen = bookTableView.contentSize.height <= bookTableView.frame.size.height
            if contentFitsScreen {
                bookTableView.tableFooterView = UIView(frame: .zero)
            } else {
                bookTableView.tableFooterView = footerButtonView
            }
        } else {
            bookTableView.tableFooterView = UIView(frame: .zero)
        }
    }
}
