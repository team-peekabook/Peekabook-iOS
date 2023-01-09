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
        static let notification = "알림"
    }
    
    struct Confirm {
        static let cancel = "취소하기"
        static let recommend = "추천하기"
    }
    
    struct PlaceHolder {
        static let recommend = "추천사를 적어주세요."
    }
    
    struct BookShelf {
        static let pick = "PICK !"
        static let editPick = "픽 수정하기"
        static let books = "Books"
    }
    
    struct BookDetail {
        static let comment = "한 마디"
        static let memo = "메모"
        static let commentHint = "한 마디를 남겨주세요."
        static let memoHint = "메모를 남겨주세요."
    }
    
    struct BookSearch {
        static let title = "책 검색하기"
        static let bookSearch = "책 제목 또는 작가명을 입력해주세요."
    }
    
    struct BookEdit {
        static let title = "책 수정하기"
        static let done = "완료"
    }
    
    struct BookProposal {
        static let title = "책 추천하기"
        static let done = "완료"
        static let personName = "받는사람"
        static let confirm = "님에게\n책을 추천하시겠어요?"
    }
    
    struct BookAdd {
        static let title = "책 등록하기"
        static let done = "완료"
    }
    
    struct Barcode {
        static let infoLabel = "책의 뒷면에 있는 ISBN 바코드가\n사각형 안에 들어오게 해주세요."
        static let infoButton = "바코드 인식이 어려우신가요?"
        static let searchLabel = "책 검색하기"
    }
    
    struct ErrorPopUp {
        static let empty = "존재하지 않는 책입니다"
        static let forText = "텍스트로 검색하기"
    }
}
