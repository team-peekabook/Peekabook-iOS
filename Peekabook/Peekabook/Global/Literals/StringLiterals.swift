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
        static let userSearch = "사용자 검색하기"
    }
    
    struct Confirm {
        static let cancel = "취소하기"
        static let recommend = "추천하기"
        static let delete = "삭제하기"
    }
    
    struct PlaceHolder {
        static let recommend = "추천사를 적어주세요."
        static let bookSearch = "책 제목 또는 작가명을 입력해주세요."
        static let userSearch = "사용자의 닉네임을 입력해주세요."
    }
    
    struct BookShelf {
        static let pick = "PICK !"
        static let editPick = "픽 수정하기"
        static let recommendBook = "책 추천하기"
        static let books = "Books"
        static let editPickDescription = "최대 3개까지 선택 가능해요."
        static let emptyPickViewDescription = "잠깐! PICK 한 책이 없어요.\nPICK 수정하기 버튼을 눌러\n추천하고 싶은 책을 PICK 해보세요!"
        static let emptyFriendPickDescription = "앗. 아직 친구가 고른 PICK이 없어요"
    }
    
    struct BookDetail {
        static let comment = "한 마디"
        static let memo = "메모"
        static let commentHint = "한 마디를 남겨주세요."
        static let memoHint = "메모를 남겨주세요."
        static let commentSample = "한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다.한마디는200자작성이가능합니다."
        static let memoSample = "메모는 50자 작성이 가능합니다.메모는 50자 작성이 가능합니다.메모는 50자 작성이 가능합니다."
    }
    
    struct BookSearch {
        static let title = "책 검색하기"
        static let bookSearch = "책 제목 또는 작가명을 입력해주세요."
        static let empty = "앗! 검색어에 해당되는 책이 없는 것 같아요.\n다른 검색어를 입력해 보세요."
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
        static let emptyUser = "앗! 해당 사용자가 존재하지 않는 것 같아요.\n다른 검색어를 입력해 보세요."
    }
    
    struct FollowStatus {
        static let follow = "팔로우"
        static let following = "팔로잉"
    }
    
    struct BookRecommend {
        static let recommended = "추천받은 책"
        static let recommending = "추천한 책"
    }
    
    struct BookDelete {
        static let popUpComment = "해당 책을\n정말 삭제하시겠습니까?"
    }
    
    struct Alarm {
        static let followAlarm = "당신을 팔로우했어요!"
        static let recommendAlarm = "당신에게 책을 추천했어요!"
        static let addBookAlarm = "책장에 새로운 책이 추가되었어요!"
    }
}
