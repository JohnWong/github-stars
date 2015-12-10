//
//  ValueStore.swift
//  Github Stars
//
//  Created by John Wong on 12/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import Foundation

class ValueStore: Any {
    static var sharedInstance = ValueStore()
    
    private static let KeyCode = "code"
    private static let KeyToken = "token"
    
    var code: String? = NSUserDefaults.standardUserDefaults().objectForKey(ValueStore.KeyCode)?.stringValue {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(code, forKey: ValueStore.KeyCode)
        }
    }
    
    var token: String? {
        get {
            if let _ = self.token {
                return self.token
            } else {
                return NSUserDefaults.standardUserDefaults().objectForKey(ValueStore.KeyToken)?.stringValue
            }
        }
        set {
            self.token = newValue
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: ValueStore.KeyToken)
        }
    }

}
