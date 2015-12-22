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
    case Initial
    case NotGranted
    case Granted
}

class ViewController: UIViewController {
    
    var status: Status = .Initial {
        willSet {
            if newValue != status {
                switch newValue {
                case .NotGranted:
                    infoLabel.text = "未授权"
                    actionButton.setTitle("点击授权", forState: .Normal)
                    break
                case .Granted:
                    infoLabel.text = "已经授权"
                    actionButton.setTitle("重新授权", forState: .Normal)
                    break
                default:
                    break
                }
            }
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didGetCode:"), name: ConstValue.Notifications.didGetCode, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAuthStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAuthStatus() {
        if let _ = ValueStore.token {
            self.status = .Granted
        } else {
            self.status = .NotGranted
        }
        
    }

    @IBAction func didTapActionButton(sender: AnyObject) {
        self.requestAuth()
    }
    
    func requestAuth() {
        let authUrl = "https://github.com/login/oauth/authorize?client_id=" + ConstValue.clientId + "&redirect_url=" + ConstValue.redirectUrl + "&scope=user:follow,public_repo"
        UIApplication .sharedApplication().openURL(NSURL(string: authUrl)!)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didGetCode(notification: NSNotification) {
        if let code = notification.object as? String {
            self.infoLabel.text = "授权中"
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
                            self.updateAuthStatus()
                        }
                        catch let errorCatched as NSError {
                            err = errorCatched
                        }
                    }
                    if let _ = err {
                        // TODO show error
                        self.infoLabel.text = "网络错误"
                        assert(false, "error")
                    }
            }
        } else {
            // Warning
            assert(false, "error")
        }
        
    }

}

