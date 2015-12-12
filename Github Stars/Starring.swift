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
    
    class func starRepo(text: String) {
        if let token = ValueStore.token {
            print("Request with token %@", token)
            let configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("Test")
            configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
            
            Manager(configuration: configuration)
                .request(
                    .PUT,
                    "https://api.github.com/user/starred/JamesNK/Newtonsoft.Json",
                    headers: [
                        "Authorization": "token " + token,
                        "Accept": "application/json"
                    ])
                .response {
                    request, response, data, error in
                    var err: NSError? = nil
                    if let _ = error {
                        err = error
                    } else if let data = data {
                        print(String(data: data, encoding: NSUTF8StringEncoding))
                    }
                    if let _ = err {
                        // TODO show error
                        assert(false, "error")
                    }
            }
        } else {
            // TODO
            assert(false, "Get token")
        }
    }
}
