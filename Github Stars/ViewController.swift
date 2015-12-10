//
//  ViewController.swift
//  Github Stars
//
//  Created by John Wong on 12/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didGetCode"), name: ConstValue.Notifications.didGetCode, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func requestAuth(sender: AnyObject) {
        
        let authUrl = "https://github.com/login/oauth/authorize?client_id=" + ConstValue.clientId + "&redirect_url=" + ConstValue.redirectUrl + "&scope=user:follow"
        UIApplication .sharedApplication().openURL(NSURL(string: authUrl)!)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didGetCode() {
        if let code = ValueStore.sharedInstance.code {
            Alamofire.request(.POST, "https://github.com/login/oauth/access_token", parameters: ["client_id": ConstValue.clientId,
                "client_secret": ConstValue.clientSecret,
                "code": code])
                .response { request, response, data, error in
                    print(request)
                    print(response)
                    print(data)
                    print(error)
        }
        } else {
            // Warning
        }
        
    }

}

