//
//  ConstValue.swift
//  Github Stars
//
//  Created by John Wong on 12/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import Foundation

class ConstValue: AnyObject {
    
    struct Notifications {
        static let didGetCode = "didGetCode"
    }
    
    static let clientId = "a091c44eda729807c12c"
    static let clientSecret = "6d021a2cc819a4b489afd53bf6e5147027ab16db"
    static let scheme = "com.johnwong.github://"
    static let redirectUrl = scheme + "oauth".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
}
