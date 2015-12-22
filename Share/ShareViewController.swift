//
//  ShareViewController.swift
//  Share
//
//  Created by John Wong on 12/12/15.
//  Copyright © 2015 John Wong. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var messageButton: UIButton!
    
    var messageTapFunc : (Void -> Void)? {
        didSet {
            self.messageButton.userInteractionEnabled = messageTapFunc != nil
        }
    }
    
    override func loadView() {
        super.loadView()
        self.loadItemWithCompletion { (url, error) -> Void in
            if let url = url {
                let (userName, repoName) = self.extractFromUrl(url);
                if let userName = userName, repoName = repoName {
                    print(userName, repoName)
                    self.loadRequest(userName: userName, repoName: repoName)
                    return
                }
            }
            var err: NSError
            if let error = error {
                err = error
            } else {
                err = Error.noRepoError()
            }
            self.showError(err, userName: "", repoName: "")
            NSLog("%@", err)
        }
    }
    
    func loadRequest(userName userName: String, repoName: String) {
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            self.showLoading()
        })
        Starring.starRepo(userName: userName, repoName: repoName, completion: {
            [weak self](error) -> Void in
            if let weakSelf = self {
                if let error = error {
                    weakSelf.showError(error, userName: userName, repoName: repoName)
                } else {
                    weakSelf.showSuccess()
                }
            }
        })
    }
    
    @IBAction func tapMessage(sender: AnyObject) {
        self.messageTapFunc?()
    }
    
    func stopLoading() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
    }
    
    func showError(error: NSError, userName: String, repoName: String) {
        self.stopLoading()
        self.messageButton.hidden = false
        if error.domain == Error.domain {
            self.messageButton.setTitle(error.localizedDescription, forState: .Normal)
            self.messageTapFunc = nil
            self.closeLater()
        } else {
            self.messageButton.setTitle("请求失败 点击重试", forState: .Normal)
            self.messageTapFunc = {
                self .loadRequest(userName: userName, repoName: repoName)
            }
        }
    }
    
    func showLoading() {
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        self.messageButton.hidden = true
        self.messageButton.setTitle(nil, forState: .Normal)
        self.messageTapFunc = nil;
    }
    
    func closeLater() {
        let sec: Int64 = Int64(1.8 * Double(NSEC_PER_SEC))
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, sec),
            dispatch_get_main_queue(),
            {
                self.close(0)
            }
        );
    }
    
    func showSuccess() {
        self.stopLoading()
        self.messageButton.setTitle("成功", forState: .Normal)
        self.messageButton.hidden = false
        self.messageTapFunc = nil
        self.closeLater()
    }
    
    func extractFromUrl(url: String) -> (String?, String?) {
        let expression: NSRegularExpression?
        do {
            try expression = NSRegularExpression(pattern: "github.com/[.0-9a-zA-Z_-]+/[.0-9a-zA-Z_-]+", options:.CaseInsensitive)
        } catch  {
            return (nil, nil)
        }
        
        let range = NSRange(location: 0, length: (url as NSString).length)
        let result = expression!.matchesInString(url, options:NSMatchingOptions(rawValue: 0), range: range)
        if let first = result.first {
            let range = Range(start: url.startIndex.advancedBy(first.range.location), end: url.startIndex.advancedBy(first.range.location + first.range.length))
            let matched = url.substringWithRange(range).substringFromIndex("github.com/".endIndex);
            let split = matched.characters.split{$0 == "/"}.map(String.init)
            return (split[0], split[1])
        }
        return (nil, nil)
    }
    
    func loadItemWithCompletion(completion: (String?, NSError!) -> Void) {
        if let item = self.extensionContext?.inputItems.first as? NSExtensionItem {
            for provider: NSItemProvider in item.attachments as! [NSItemProvider] {
                if let dataType = provider.registeredTypeIdentifiers.first as? String {
                    if dataType == kUTTypePlainText as String || dataType == kUTTypeURL as String {
                        provider.loadItemForTypeIdentifier(dataType, options: nil, completionHandler: { (coding, error) -> Void in
                            if coding is String {
                                print("String")
                                completion(coding as? String, nil)
                            } else if coding is NSURL {
                                print("NSURL")
                                completion((coding as! NSURL).absoluteString, nil)
                            } else {
                                print(error)
                                completion(nil, Error.shareFetchError())
                            }
                        })
                        return
                    }
                }
            }
        }
        completion(nil, Error.shareTypeError())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func close(sender: AnyObject) {
        self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
    }
    
    func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

}
