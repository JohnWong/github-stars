//
//  ValueStore.swift
//  Github Stars
//
//  Created by John Wong on 12/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import Foundation

class ValueStore: Any {
    
    private static let KeyCode = "code"
    private static let KeyToken = "token"
    private static let KeyScope = "scope"
    
    static var code: String? = NSUserDefaults.standardUserDefaults().objectForKey(ValueStore.KeyCode) as? String {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(code, forKey: ValueStore.KeyCode)
        }
    }
    
    static var token: String? = NSUserDefaults.standardUserDefaults().objectForKey(ValueStore.KeyToken) as? String {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: ValueStore.KeyToken)
        }
    }
    
    static var scope: String? = NSUserDefaults.standardUserDefaults().objectForKey(ValueStore.KeyScope) as? String {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(scope, forKey: ValueStore.KeyScope)
        }
    }

}
