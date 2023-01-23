//
//  NaverSearchAPI.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/09.
//

import Foundation

import Moya

final class NaverSearchAPI {
    
    static var shared = NaverSearchAPI()
    
    let jsconDecoder: JSONDecoder = JSONDecoder()
    
    var bookInfoList: [BookInfoModel] = []
    let booksearchVC = BookSearchVC()
    let addBookVC = AddBookVC()
    
    private func urlTitleTaskDone() -> [BookInfoModel] {
        var model: [BookInfoModel] = []
        guard let searchData = DataManager.shared.searchResult else { return model }
        
        for i in 0..<searchData.items.count {
            model.append(BookInfoModel(image: searchData.items[i].image, title: searchData.items[i].title, author: searchData.items[i].author))
        }
        return model
    }
    
    // 네이버 책검색 API 불러오기
    
    func getNaverBookTitleAPI(d_titl: String, d_isbn: String, display: Int, completion: @escaping ([BookInfoModel]?) -> Void) {
        
        let clientID: String = Config.naverClientId
        let clientKEY: String = Config.naverClientSecret
        
        let searchURL: String = Config.naverBookSearchURL
        let _: String = searchURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        var queryURL: URLComponents = URLComponents(string: searchURL)!
        
        var queryItems: [URLQueryItem] = []
        let titleQuery: URLQueryItem = URLQueryItem(name: "d_titl", value: d_titl)
        let displayQuery: URLQueryItem = URLQueryItem(name: "display", value: "\(display)")
        let isbnQuery: URLQueryItem = URLQueryItem(name: "d_isbn", value: d_isbn)
        
        queryItems.append(titleQuery)
        queryItems.append(displayQuery)
        queryItems.append(isbnQuery)
        queryURL.queryItems = queryItems
        
        var requestURL = URLRequest(url: queryURL.url!)
        requestURL.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else { print(error as Any); return }
            guard let data = data else { print(error as Any); return }
            
            do {
                var bookTitle = ""
                if let titleQ = titleQuery.value {
                    bookTitle = titleQ
                    if bookTitle.isEmpty {
                        print("isbn 검색을 하겠습니다")
                        let searchInfo: PostBook = try self.jsconDecoder.decode(PostBook.self, from: data)
                        DataManager.shared.searchResult = searchInfo
                        completion(self.urlTitleTaskDone())
                    } else {
                        print("텍스트 검색을 하겠습니다")
                        let searchInfo: PostBook = try self.jsconDecoder.decode(PostBook.self, from: data)
                        DataManager.shared.searchResult = searchInfo
                        completion(self.urlTitleTaskDone())
                    }
                }
            } catch {
                fatalError()
            }
        }
        task.resume()
    }
}
