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
    
    var titleList: [String] = []
    var imageList: [String] = []
    var authorList: [String] = []
    var bookInfoList: [BookInfoModel] = []

    let booksearchVC = BookSearchVC()
    
    func urlTitleTaskDone() -> [BookInfoModel] {
        let SearchData = DataManager.shared.searchResult
        var model: [BookInfoModel] = []
        do {
            for i in 0...9 {
                model.append(BookInfoModel(image: SearchData?.items[i].image ?? "", title: SearchData?.items[i].title ?? "", author: SearchData?.items[i].author ?? ""))
            }
            return model
        } catch {}
    }
    
    // 네이버 책검색 API 불러오기
    
    func getNaverBookAPI(d_titl: String, d_isbn: String, display: Int, completion: @escaping ([BookInfoModel]?) -> Void) {
        
        let clientID: String = Config.naverClientId
        let clientKEY: String = Config.naverClientSecret
        
        let searchURL: String = Config.naverBookSearchURL
        let encodedQuery: String = searchURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        var queryURL: URLComponents = URLComponents(string: searchURL)!
        var titleQuery: URLQueryItem = URLQueryItem(name: "d_titl", value: d_titl)
        queryURL.queryItems?.append(titleQuery)
        
        var displayQuery: URLQueryItem = URLQueryItem(name: "display", value: "\(display)")
        queryURL.queryItems?.append(displayQuery)
        
        var isbnQuery: URLQueryItem = URLQueryItem(name: "d_isbn", value: d_isbn)
        queryURL.queryItems?.append(isbnQuery)
        
        var requestURL = URLRequest(url: queryURL.url!)
        requestURL.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else { print(error); return }
            guard let data = data else { print(error); return }
            
            do {
                let searchInfo: PostBook = try self.jsconDecoder.decode(PostBook.self, from: data)
                DataManager.shared.searchResult = searchInfo
                
                completion(self.urlTitleTaskDone())
            } catch {
                print(fatalError())
            }
        }
        task.resume()
    }
}
