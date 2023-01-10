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
    
    func urlTaskDone() {
            let item = DataManager.shared.searchResult?.items[0]
            print(item)
        }
    
    // 네이버 책검색 API 불러오기
    
    func getNaverBookAPI(d_titl: String) {
        
        let clientID: String = Config.naverClientId
        let clientKEY: String = Config.naverClientSecret
        
        let query: String = Config.naverBookSearchURL
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let queryURL: URL = URL(string: encodedQuery)!
       
        var requestURL = URLRequest(url: queryURL)
        requestURL.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        requestURL.addValue(clientKEY, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: requestURL) { data, response, error in
            guard error == nil else { print(error); return }
            guard let data = data else { print(error); return }
            
            do {
                let searchInfo: NaverSearchResponse = try self.jsconDecoder.decode(NaverSearchResponse.self, from: data)
                DataManager.shared.searchResult = searchInfo
                self.urlTaskDone()
            } catch {
                print(fatalError())
            }
        }
        task.resume()
    }
}
