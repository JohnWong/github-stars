//
//  ValueStore.swift
//  Github Stars
//
//  Created by John Wong on 12/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import Foundation

class ValueStore: Any {
    
    static let groupId = "group.com.johnwong.github"
    private static let KeyCode = "code"
    private static let KeyToken = "token"
    private static let KeyScope = "scope"
    private static let userDefaults: NSUserDefaults = NSUserDefaults(suiteName: groupId)!
    
    static var code: String? {
        set {
            userDefaults.setObject(code, forKey: ValueStore.KeyCode)
            userDefaults.synchronize()
        }
        
        get {
            return userDefaults.objectForKey(ValueStore.KeyCode) as? String
        }
    }
    
    static var token: String? {
        set {
            userDefaults.setObject(token, forKey: ValueStore.KeyToken)
            userDefaults.synchronize()
        }
        
        get {
            return userDefaults.objectForKey(ValueStore.KeyToken) as? String
        }
    }
    
    static var scope: String? {
        set {
            userDefaults.setObject(scope, forKey: ValueStore.KeyScope)
            userDefaults.synchronize()
        }
        
        get {
            return userDefaults.objectForKey(ValueStore.KeyScope) as? String
        }
    }

}
