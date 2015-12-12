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

    var isFetched = false
    var onceToken:dispatch_once_t = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func isContentValid() -> Bool {
        if isFetched {
            true
        }
        if let item = self.extensionContext?.inputItems.first as? NSExtensionItem{
            for provider: NSItemProvider in item.attachments as! [NSItemProvider] {
                if let dataType = provider.registeredTypeIdentifiers.first as? String {
                    if dataType == kUTTypePlainText as String || dataType == kUTTypeURL as String {
                        dispatch_once(&onceToken, { () -> Void  in
                            provider.loadItemForTypeIdentifier(dataType, options: nil, completionHandler: { (coding, error) -> Void in
                                if coding is String {
                                    print("String")
                                } else if coding is NSURL {
                                    print("NSURL")
                                }
                                self.isFetched = true
                            })
                        });
                        return true
                    }
                }
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
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
