//
//  StringLiterals.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

struct I18N {
    
    struct Alert {
        static let error = "에러"
        static let networkError = "네트워크 오류가 발생하였습니다."
        static let emptyNoti = "앗! 준비 중인 기능이에요."
    }
    
    struct Tabbar {
        static let bookshelf = "책장"
        static let recommend = "추천 "
        static let mypage = "MY"
    }
    
    struct Confirm {
        static let cancel = "취소하기"
        static let recommend = "추천하기"
    }
    
    struct PlaceHolder {
        static let recommend = "추천사를 적어주세요."
        static let bookSearch = "책 제목 또는 작가명을 입력해주세요."
    }
    
    struct BookShelf {
        static let pick = "PICK !"
        static let editPick = "픽 수정하기"
        static let books = "Books"
    }
}
