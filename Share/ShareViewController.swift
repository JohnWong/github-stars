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
                    Starring.starRepo(userName: userName, repoName: repoName, completion: { (error) -> Void in
                        if let error = error {
                            self.showError(error)
                        } else {
                            self.showSuccess()
                        }
                    })
                }
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    @IBAction func tapMessage(sender: AnyObject) {
        self.messageTapFunc?()
    }
    
    func showError(error: NSError) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.messageButton.setTitle(error.localizedDescription, forState: .Normal)
        self.messageButton.hidden = false
        if error.code == ErrorCode.emptyToken.rawValue {
            self.messageTapFunc = nil
        } else {
            self.messageTapFunc = {
                
            }
        }
    }
    
    func showSuccess() {
        self.messageTapFunc = nil
        self.activityIndicator.stopAnimating()
        self.activityIndicator.hidden = true
        self.messageButton.setTitle("成功", forState: .Normal)
        self.messageButton.hidden = false
        self.messageTapFunc = nil
        let sec: Int64 = 2 * Int64(NSEC_PER_SEC)
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, sec),
            dispatch_get_main_queue(),
            {
                self.close(0)
            });
    }
    
    func extractFromUrl(url: String) -> (String?, String?) {
        let expression: NSRegularExpression?
        do {
            try expression = NSRegularExpression(pattern: "github.com/[.0-9a-zA-Z_-]+/[.0-9a-zA-Z_-]+", options:.CaseInsensitive)
        } catch  {
            return (nil, nil)
        }
        let result = expression!.matchesInString(url, options:NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: url.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
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
        self.activityIndicator.startAnimating()
        self.messageButton.hidden = true
        self.messageTapFunc = nil;
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
