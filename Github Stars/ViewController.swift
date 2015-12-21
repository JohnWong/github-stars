//
//  ViewController.swift
//  Github Stars
//
//  Created by John Wong on 12/11/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import UIKit
import Alamofire

enum Status {
    case NotGranted
    case FetchingToken
    case Granted
}

class ViewController: UIViewController {
    
    var status: Status = .NotGranted
    
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didGetCode"), name: ConstValue.Notifications.didGetCode, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAuthStatus() {
        if let _ = ValueStore.token {
            self.status = .Granted
        } else if let _ = ValueStore.code {
            self.status = .FetchingToken
        } else {
            self.status = .NotGranted
        }
        switch self.status {

        }
    }

    @IBAction func requestAuth(sender: AnyObject) {
        
        let authUrl = "https://github.com/login/oauth/authorize?client_id=" + ConstValue.clientId + "&redirect_url=" + ConstValue.redirectUrl + "&scope=user:follow,public_repo"
        UIApplication .sharedApplication().openURL(NSURL(string: authUrl)!)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didGetCode() {
        if let code = ValueStore.code {
            Alamofire.request(.POST, "https://github.com/login/oauth/access_token", parameters: [
                    "client_id": ConstValue.clientId,
                    "client_secret": ConstValue.clientSecret,
                    "code": code
                ],
                encoding: .URL,
                headers: [
                    "Accept": "application/json"
                ])
                .response { request, response, data, error in
                    var err: NSError? = nil
                    if let _ = error {
                        err = error
                    } else if let data = data {
                        print(String(data: data, encoding: NSUTF8StringEncoding))
                        var result: Dictionary<String, String>?
                        do {
                            try result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Dictionary<String, String>
                            ValueStore.scope = result!["scope"]
                            ValueStore.token = result!["access_token"]
                        }
                        catch let errorCatched as NSError {
                            err = errorCatched
                        }
                    }
                    if let _ = err {
                        // TODO show error
                        assert(false, "error")
                    }
            }
        } else {
            // Warning
            assert(false, "error")
        }
        
    }

}

