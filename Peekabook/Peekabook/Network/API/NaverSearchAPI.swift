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
    let booksearchVC = BookSearchVC()
    
    func urlTitleTaskDone() {
        let wholeList = DataManager.shared.searchResult
        do {
            for i in 0...9 {
                titleList.append((wholeList?.items[i].title)!)
                imageList.append((wholeList?.items[i].image)!)
                authorList.append((wholeList?.items[i].author)!)
            }
            print(titleList)
            print(imageList)
            print(authorList)
//            booksearchVC.titleList = titleList
        } catch {}
    }
    
    func urlIsbnTaskDone() {
        let wholeList = DataManager.shared.searchResult
        do {
            var i = 0
            titleList.append((wholeList?.items[i].title)!)
            imageList.append((wholeList?.items[i].image)!)
            authorList.append((wholeList?.items[i].author)!)
            print(titleList)
            print(imageList)
            print(authorList)
        } catch {}
    }
    
    // 네이버 책검색 API 불러오기
    
    func getNaverBookAPI(d_titl: String, d_isbn: String) {
        
        let clientID: String = Config.naverClientId
        let clientKEY: String = Config.naverClientSecret
        
        let searchURL: String = Config.naverBookSearchURL
        let encodedQuery: String = searchURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        var queryURL: URLComponents = URLComponents(string: searchURL)!
        var titleQuery: URLQueryItem = URLQueryItem(name: "d_titl", value: d_titl)
        queryURL.queryItems?.append(titleQuery)
        
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
                
//                print(queryURL.queryItems)
//                print(titleQuery.value)
//                print(isbnQuery.value)
//                var bookTitle = ""
//                if let titleQ = titleQuery.value {
//                    bookTitle = titleQ
//                    print(bookTitle)
//                    if bookTitle == nil {
//                        self.urlIsbnTaskDone()
//                    } else {
//                        self.urlTitleTaskDone()
//                    }
//                }
                
                self.urlTitleTaskDone()
                
//                self.urlIsbnTaskDone()
                
            } catch {
                print(fatalError())
            }
        }
        task.resume()
    }
}
