//
//  WebViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var article:Article?
    
    @IBOutlet weak var webViewer: UIWebView!
    
    //activity indicator variables
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = article!.section
        
        let requestString = article!.url
        
        showActivityIndicator(self.view)
        
        if requestString != nil{
            let requestURL = NSURL(string: requestString!)
            let request = NSURLRequest(URL: requestURL!)
            webViewer.loadRequest(request)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        hideActivityIndicator(self.view)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        hideActivityIndicator(self.view)
        var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    

    func showActivityIndicator(uiView: UIView) {
        //courtesey of eranga bandara
        
        container.frame = uiView.frame
        container.center = uiView.center
        //container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
        
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        //loadingView.backgroundColor = UIColorFromHex(0x999999, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        actInd.color = self.view.tintColor
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
            loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        actInd.stopAnimating()
        loadingView.removeFromSuperview()
        container.removeFromSuperview()
        
    }

}
