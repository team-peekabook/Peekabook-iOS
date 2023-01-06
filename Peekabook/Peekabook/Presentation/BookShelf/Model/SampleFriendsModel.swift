//
//  SampleFriendsModel.swift
//  Peekabook
//
//  Created by devxsby on 2023/01/04.
//

import UIKit

struct SampleFriendsModel {
    var name: String
    var profileImage: UIImage
}

extension SampleFriendsModel {
    static var data: [SampleFriendsModel] {
        return [
            SampleFriendsModel(name: "김인영", profileImage: ImageLiterals.Sample.profile1!),
            SampleFriendsModel(name: "고두영두영", profileImage: ImageLiterals.Sample.profile2!),
            SampleFriendsModel(name: "박현정", profileImage: ImageLiterals.Sample.profile3!),
            SampleFriendsModel(name: "한지우지우지우", profileImage: ImageLiterals.Sample.profile4!),
            SampleFriendsModel(name: "조예슬", profileImage: ImageLiterals.Sample.profile5!),
            SampleFriendsModel(name: "이영주", profileImage: ImageLiterals.Sample.profile6!),
            SampleFriendsModel(name: "이현우", profileImage: ImageLiterals.Sample.profile1!),
            SampleFriendsModel(name: "문수빈", profileImage: ImageLiterals.Sample.profile2!)
        ]
    }
}
