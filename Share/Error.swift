//
//  Error.swift
//  Github Stars
//
//  Created by John Wong on 12/19/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import UIKit

enum ErrorCode: Int {
    case emptyToken = 1
    case shareType
    case shareFetch
}

class Error: NSObject {
    
    static let domain = "JW"
    
    class func emptyTokenError() -> NSError {
        return NSError(domain: domain, code: ErrorCode.emptyToken.rawValue, userInfo: [
            NSLocalizedDescriptionKey: "请先到应用中授予权限"
        ])
    }
    
    class func shareTypeError() -> NSError {
        return NSError(domain: domain, code: ErrorCode.shareType.rawValue, userInfo: [
            NSLocalizedDescriptionKey: "分享类型非文本或链接"
        ])
    }
    
    class func shareFetchError() -> NSError {
        return NSError(domain: domain, code: ErrorCode.shareFetch.rawValue, userInfo: [
            NSLocalizedDescriptionKey: "获取分享信息出错"
        ])
    }
    
    
    

}
