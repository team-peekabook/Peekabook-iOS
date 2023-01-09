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
    
    private lazy var touchCancelButton = UIButton().then {
        $0.addTarget(self, action: #selector(touchCancelButtonDidTap), for: .touchUpInside)
    }
    
    private let headerTitle = UILabel().then {
        $0.text = "책 검색하기"
        $0.font = .h3
        $0.textColor = .peekaRed
    }
    
    private let headerLine = UIView()
    
    private lazy var searchButton = UIButton().then {
        $0.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var searchField = UITextField().then {
        $0.backgroundColor = .white
        $0.font = .h2
        $0.textColor = .peekaRed
        $0.attributedPlaceholder = NSAttributedString(string: I18N.PlaceHolder.bookSearch,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.peekaGray1])
        $0.addLeftPadding()
        $0.rightViewMode = UITextField.ViewMode.always
        $0.rightView = searchButton
    }
    
    private lazy var bookTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = .peekaBeige
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        }()
    
    private var bookInfoList: [BookInfoModel] = [
        BookInfoModel(image: ImageLiterals.Sample.book1, title: "아무튼, 여름", author: "김신회"),
        BookInfoModel(image: ImageLiterals.Sample.book2, title: "아무튼, 두영", author: "김인영"),
        BookInfoModel(image: ImageLiterals.Sample.book3, title: "아무튼, 수빈", author: "고두영"),
        BookInfoModel(image: ImageLiterals.Sample.book4, title: "아무튼, 인영", author: "윤수빈")
    ]

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        register()
        addTapGesture()
    }
}

// MARK: - UI & Layout
extension BookSearchVC {
    private func setUI() {
        self.view.backgroundColor = .peekaBeige
        headerView.backgroundColor = .clear
        headerLine.backgroundColor = .peekaRed
        
        touchCancelButton.setImage(ImageLiterals.Icn.close, for: .normal)
        searchButton.setImage(ImageLiterals.Icn.search, for: .normal)
    }
    
    private func setLayout() {
        [headerView, searchField, headerLine, bookTableView].forEach {
            view.addSubview($0)
        }
        
        [touchCancelButton, headerTitle].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        
        touchCancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        headerTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        headerLine.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
        }
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bookTableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(128 * bookInfoList.count)
        }
    }
    
    private func register() {
        bookTableView.register(BookInfoTableViewCell.self, forCellReuseIdentifier: BookInfoTableViewCell.identifier)
    }
    
    // MARK: - @objc Function
    
    @objc
    private func touchCancelButtonDidTap() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func popToSearchView() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Methods

extension BookSearchVC {
    
    // TODO: - 버튼 액션 구현 필요
    @objc private func searchButtonDidTap() {
        // do something
    }
}

extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}

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
        guard let bookCell = tableView.dequeueReusableCell(withIdentifier: BookInfoTableViewCell.identifier, for: indexPath) as? BookInfoTableViewCell else { return UITableViewCell() }
        
        bookCell.dataBind(model: bookInfoList[indexPath.row])
        return bookCell
    }
}
