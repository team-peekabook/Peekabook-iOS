//
//  SampleUserModel.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

struct SampleUserModel {
    var name: String
    var introduction: String
}

extension SampleUserModel {
    static var data: [SampleUserModel] {
        return [
            SampleUserModel(name: "윤수빈", introduction: "안녕하세요, 저는 한줄소개 입니다! 제 책장을 둘러보세요! 글자가 최대 몇자일까")
        ]
    }
}
