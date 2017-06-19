//
//  Extensions.swift
//  Schoolert
//
//  Created by Ricky Avina on 6/18/17.
//  Copyright © 2017 InternTeam. All rights reserved.
//

import Foundation

extension String {
    var nsString: NSString { return self as NSString }
    var length: Int { return nsString.length }
    var nsRange: NSRange { return NSRange(location: 0, length: length) }
    var detectDates: [Date]? {
        return try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
            .matches(in: self, range: nsRange)
            .flatMap{$0.date}
    }
}

extension Collection where Iterator.Element == String {
    var dates: [Date] {
        return flatMap{$0.detectDates}.flatMap{$0}
    }
}
