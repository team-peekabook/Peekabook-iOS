//
//  SampleBookModel.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

struct SampleBookModel {
    var bookImage: UIImage
}

extension SampleBookModel {
    static var data: [SampleBookModel] {
        return [
            SampleBookModel(bookImage: ImageLiterals.Sample.book1!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book2!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book3!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book4!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book5!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book1!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book2!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book3!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book4!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book5!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book1!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book2!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book3!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book4!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book5!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book1!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book2!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book3!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book4!),
            SampleBookModel(bookImage: ImageLiterals.Sample.book5!)
        ]
    }
}
