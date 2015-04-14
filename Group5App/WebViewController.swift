//
//  WebViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var article:Article?
    
    
    @IBOutlet weak var webViewer: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = article!.section
        
        let requestString = article!.url
        
        if requestString != nil{
            let requestURL = NSURL(string: requestString!)
            let request = NSURLRequest(URL: requestURL!)
            webViewer.loadRequest(request)
        }
    }

}
