//
//  getClassName.swift
//  Peekabook
//
//  Created by devxsby on 2022/12/31.
//

import UIKit

extension NSObject {
    
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}
