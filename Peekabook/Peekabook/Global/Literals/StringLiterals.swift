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
        static let networkError = "앗! 네트워크 연결에 실패했어요.\n확인 후 다시 시도해주세요."
        static let retry = "다시 시도하기"
        static let emptyNoti = "앗! 준비 중인 기능이에요."
    }
    
    struct Tabbar {
        static let bookshelf = "책장"
        static let recommend = "추천"
        static let mypage = "MY"
    }
    
    struct Onboarding {
        static let startButton = "내 책장 만들러 가기"
        static let first = "반가워요!\nPEEK-A-BOOK은 서로의 책장을 공유하고,\n새로운 책을 발견해나가는 서비스예요."
        static let second = "내가 가지고 있는 책의 바코드를 스캔하여\n책장에 추가할 수 있어요.\n책장에 책을 채우며 자신의 취향을 드러내보아요."
        static let third = "\n닉네임 검색을 통해 친구를 추가하고,\n친구와 서로의 책장을 공유해요!"
        static let fourth = "\n친구에게 먼저 책을 추천해 주면\n친구도 나에게 책을 추천해 줄지도 몰라요!"
    }
    
    struct Confirm {
        static let cancel = "취소하기"
        static let recommend = "추천하기"
        static let delete = "삭제하기"
    }
    
    struct PlaceHolder {
        static let recommend = "추천사를 적어주세요"
        static let bookSearch = "책 제목을 입력해주세요."
        static let userSearch = "사용자의 닉네임을 입력해주세요."
        static let nickname = "닉네임은 6자까지 쓸 수 있어요!"
        static let profileIntro = "한 줄 소개를 입력해주세요."
    }
    
    struct BookShelf {
        static let pick = "PICK !"
        static let editPick = "픽 수정하기"
        static let recommendBook = "책 추천하기"
        static let books = "Books"
        static let editPickDescription = "최대 3개까지 선택 가능해요."
        static let emptyPickViewDescription = "잠깐! PICK한 책이 없어요.\nPICK 수정하기 버튼을 눌러\n추천하고 싶은 책을 PICK 해보세요!"
        static let emptyFriendPickDescription = "앗! 친구가 PICK한 책이 없어요.\n책 추천하기 버튼을 눌러\n친구에게 책을 추천 해보세요!"
        static let emptyFriendListDescription = "친구추가 버튼을 눌러 친구를 추가해보세요!"
        static let emptyMyBottomBookShelfDescription = "아직 책장에 책이 없어요.\n+ 버튼을 눌러 좋아하는 책을 추가해볼까요?"
        static let emptyFriendBottomBookShelfDescription = "친구 책장이 텅 비어있어요!"
        static let unfollow = "언팔로우"
        static let report = "신고하기"
        static let block = "차단하기"
        static let cancel = "취소"
    }
    
    struct BookDetail {
        static let comment = "한 마디"
        static let memo = "메모"
        static let commentPlaceholder = "책을 읽고 느낀 점, 좋았던 구절을 적어보세요."
        static let memoPlaceholder = "메모에 적은 내용은 나만 볼 수 있어요.\nex) 7/3~7/10 완독, 두두에게 선물 받음"
        static let emptyComment = "작성된 한 마디가 없습니다"
        static let emptyMemo = "작성된 메모가 없습니다"
    }
    
    struct BookSearch {
        static let title = "책 검색하기"
        static let bookSearch = "책 제목을 입력해주세요."
        static let empty = "앗! 검색어에 해당되는 책이 없는 것 같아요.\n다른 검색어를 입력해 보세요."
        static let addMyBookshelf = "내 책장에 추가하기"
        static let recommendFriendBookShelf = "친구에게 책 추천하기"
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
        static let commentLength = "0/200"
        static let memoLength = "0/50"
    }
    
    struct Barcode {
        static let infoLabel = "책의 뒷면에 있는 ISBN 바코드가\n사각형 안에 들어오게 해주세요."
        static let infoButton = "책 제목으로 검색하기"
        static let searchLabel = "책 검색하기"
    }
    
    struct ErrorPopUp {
        static let empty = "존재하지 않는 책입니다"
        static let forText = "텍스트로 검색하기"
        static let emptyUser = "앗! 해당 사용자가 존재하지 않는 것 같아요.\n다른 검색어를 입력해 보세요."
    }
    
    struct FollowStatus {
        static let userSearch = "사용자 검색하기"
        static let follow = "팔로우"
        static let following = "팔로잉"
        static let unfollowComment = "님을\n언팔로우 하시겠어요?"
        static let unfollow = "언팔로우"
    }
    
    struct BookRecommend {
        static let recommended = "추천받은 책"
        static let recommending = "추천한 책"
        static let edit = "수정하기"
        static let complete = "완료"
        static let recommendedEmptyDescription = "아직 친구가 추천해준 책이 없어요.\n친구와 함께 읽을 책을 공유해보세요."
        static let recommendingEmptyDescription = "친구에게 추천한 책이 없어요.\n친구와 함께 읽을 책을 공유해보세요."
    }
    
    struct BookDelete {
        static let popUpComment = "해당 책을\n정말 삭제하시겠습니까?"
    }
    
    struct Alarm {
        static let notification = "알림"
        static let followAlarm = "당신을 팔로우했어요!"
        static let recommendAlarm = "당신에게 책을 추천했어요!"
        static let addBookAlarm = "책장에 새로운 책이 추가되었어요!"
        static let emptyDescription = "새로운 알림이 없습니다." // 임시
    }
    
    struct ManageBlockUsers {
        static let manageBlockedUsers = "차단사용자 관리하기"
        static let blockedUsers = "차단된 계정"
        static let unblock = "차단 해제"
        static let cancel = "취소하기"
        static let noblockedUsers = "차단된 사용자가 없어요."
        static let unblockPopUpTitle = "님을 차단 해제하시겠어요?"
        static let unblockPopSubtitle = "이제 서로에게 책을 추천할 수 있으며,\n서로의 프로필을 볼 수 있게 됩니다."
    }
    
    struct BlockPopUp {
        static let block = "차단하기"
        static let blockComment = "님을 차단하시겠어요?"
        static let blockDetailComment = "서로에게 추천한 책이 삭제되며,\n서로의 프로필을 볼 수 없게 돼요."
    }
    
    struct RecommendingPopUp {
        static let delete = "삭제하기"
        static let deleteComment = "추천한 책을 삭제하시겠어요?"
        static let deleteDetailComment = "추천받은 사용자의 추천 내역에서도 사라지며,\n삭제 후에는 되돌릴 수 없어요."
    }
    
    struct RecommendedPopUp {
        static let delete = "삭제하기"
        static let deleteComment = "추천받은 책을 삭제하시겠어요?"
        static let deleteDetailComment = "나에게 추천해준 사용자의 추천 내역에서도 사라지며,\n삭제 후에는 되돌릴 수 없어요."
    }
    
    struct BookDuplicatePopUp {
        static let add = "추가하기"
        static let duplicateComment = "이미 내 책장에 있는 도서예요.\n하나 더 추가하시겠어요?"
    }
    
    struct Logout {
        static let logout = "로그아웃"
        static let logoutComment = "로그아웃 하시겠어요?"
    }
    
    struct DeleteAccount {
        static let title = "서비스 탈퇴"
        static let deleteAccountComment = "서비스 탈퇴 시,\n사용자의 데이터는 복구되지 않습니다.\n사용자의 개인 정보는 ‘개인정보 보호방침'에 따라\n일정 기간 보관 후 파기됩니다."
        static let button = "탈퇴하기"
        static let popUpComment = "서비스 탈퇴 완료"
        static let popUpDetailComment = "이용해주셔서 감사합니다."
        static let confirm = "확인"
    }
    
    struct MyPageOption {
        static let notificationSetting = "알림 설정"
        static let privacyPolicy = "개인정보 보호 정책 & 서비스 이용 약관"
        static let contactUs = "문의하기"
        static let developerInfo = "개발자 정보"
        static let logout = "로그아웃"
        static let deleteAccount = "서비스 탈퇴하기"
    }
    
    struct Report {
        static let title = "사용자 신고하기"
        static let selectTitle = "신고 사유 선택"
        static let post = "부적절한 게시물"
        static let insults = "욕설 및 비하 발언"
        static let promote = "홍보성 컨텐츠"
        static let nickname = "닉네임 신고"
        static let etc = "기타"
        static let placeholder = "구체적인 신고 사유를 작성해 주세요."
        static let info = "신고하신 내용은 검토 후 빠른 시일 내 조치하겠습니다."
        static let buttonTitle = "신고하기"
        static let reportInfo = "신고하신 내용은 검토 후 빠른 시일 내 조치하겠습니다."
        static let reportLabel = "신고가 정상적으로 접수되었습니다."
        static let backTohome = "홈으로 돌아가기"
    }

    struct Profile {
        static let editmyPage = "프로필 수정"
        static let addMyInfo = "회원정보 입력"
        static let nickname = "닉네임"
        static let oneLineIntro = "한 줄 소개"
        static let doubleCheck = "중복 확인"
        static let doubleCheckError = "이미 사용 중인 닉네임 입니다"
        static let doubleCheckSuccess = "사용 가능한 닉네임 입니다"
        static let doubleUncheckedError = "닉네임 중복확인을 해주세요"
        static let nicknameLength = "/6"
    }

    struct Login {
        static let info = "가입 시, PEEKABOOK의 다음 사항에 동의하는 것으로 간주합니다."
        static let serviceTerms = "서비스 이용약관"
        static let privacyPolicy = "개인정보 정책"
        static let and = "및"
    }
    
    struct Update {
        static let update = "앗! 피카북이 달라졌어요"
        static let updateComment = "어떤 기능이 추가되었는지 알아볼까요?"
        static let button = "업데이트 하러가기"
    }
}
