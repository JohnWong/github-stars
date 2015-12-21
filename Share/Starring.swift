//
//  Starring.swift
//  Github Stars
//
//  Created by John Wong on 12/12/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import Foundation
import Alamofire

class Starring {
    
    static var manager : Manager = {
        Void -> Manager in
        let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("Test")
        configuration.sharedContainerIdentifier = ValueStore.groupId
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return Manager(configuration: configuration)
    }()
    
    class func starRepo(userName userName: String, repoName: String, completion: (NSError?) -> Void) {
        if let token = ValueStore.token {
            print("Request with token ", token)
            
            let url = "https://api.github.com/user/starred/" + userName + "/" + repoName
            print(url)
            self.manager
                .request(
                    .PUT,
                    url,
                    headers: [
                        "Authorization": "token " + token,
                        "Accept": "application/json"
                    ])
                .response {
                    request, response, data, error in
                    dispatch_async(dispatch_get_main_queue(), {
                        if let _ = error {
                            print(error)
                            completion(error)
                        } else if let data = data {
                            print(String(data: data, encoding: NSUTF8StringEncoding))
                            completion(nil)
                        }
                    })
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                Void -> Void in
                completion(Error.emptyTokenError())
            })
        }
    }
}
