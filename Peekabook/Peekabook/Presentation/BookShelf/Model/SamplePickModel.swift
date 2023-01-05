//
//  SamplePickModel.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

struct SamplePickModel {
    var bookId: Int  // 실제 bookId인데 일단 n번째 pick자리에 사용했습니다.
    var name: String
    var image: UIImage
    var title: String?
}

extension SamplePickModel {
    static var data: [SamplePickModel] {
        return [
            SamplePickModel(bookId: 1, name: "하둘셋넷다여일", image: ImageLiterals.Sample.book1!, title: "하둘셋넷다여일여아열하둘셋넷다여일여아열하둘셋넷다여일여아열하둘셋넷다여일여"),
            SamplePickModel(bookId: 2, name: "2번픽", image: ImageLiterals.Sample.book2!, title: nil),
            SamplePickModel(bookId: 3, name: "3번픽이에요", image: ImageLiterals.Sample.book3!, title: "안녕하세요")
        ]
    }
}
