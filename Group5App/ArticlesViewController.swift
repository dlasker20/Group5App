//
//  ArticlesViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class CustomTableViewCell : UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellHeadline: UILabel!
    @IBOutlet weak var cellDetail: UILabel!
    
    
}

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var articleTableView: UITableView!
    
    
    //activity indicator variables
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //declare instance of parser class
    let parseConnect = parser()
    //declare reuseidentifier as constant
    let reuseidentifier = "articleCell"
    
    let customReuse = "customCell"
    
    let webViewSegue = "showStory"
    
    let urlString = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/Arts/1.json?api-key=b32dcf0a887c83fe37220653ad10c91b:8:71573066"
    
    //article to be sent to web view
    var selectedArticle:Article? = nil
    
    //cache for downloaded images
    var imageCache = [String : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tell table to use custom cell described in CustomTableViewCell.xib
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        articleTableView.registerNib(nib, forCellReuseIdentifier: customReuse)
        
        showActivityIndicator(self.view)
        
        articleTableView.tableFooterView = UIView(frame: CGRectZero)
        
        parseConnect.load(urlString) {
            (companies, errorString) -> Void in
            if let unwrappedErrorString = errorString {
                // can do something about error here
                println(unwrappedErrorString)
            } else {
                self.hideActivityIndicator(self.view)
                self.articleTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            }
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseConnect.articles.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(customReuse, forIndexPath: indexPath) as! CustomTableViewCell
        
        
        self.articleTableView.estimatedRowHeight = 44.0
        self.articleTableView.rowHeight = UITableViewAutomaticDimension
        
        //set default images to load before the Asynchronous Request, in case images have long load time
        var rnum = 1+(arc4random()%4)
        let pic = UIImage(named: "dummy\(rnum)")
        cell.cellImage.image = pic
        
        
        //use asynchronous request to load images from API
        let articleImageURL = parseConnect.articles[indexPath.row].image?.url
        println(articleImageURL)
        var imgURL: NSURL = NSURL(string: articleImageURL!)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    cell.cellImage.image = UIImage(data: data)!
                    cell.setNeedsLayout()
                    cell.layoutIfNeeded()
                }
                
        })
        
        cell.cellHeadline?.text = parseConnect.articles[indexPath.row].title
        cell.cellDetail?.text = parseConnect.articles[indexPath.row].section
        ArticlesViewController().hideActivityIndicator(self.view)
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArticle = parseConnect.articles[indexPath.row]
        performSegueWithIdentifier(webViewSegue, sender: self)
    }
    
    //on segue, send article object containing url for webView
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == webViewSegue){
            let destinationViewController = segue.destinationViewController as! WebViewController
            destinationViewController.article = selectedArticle
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func schedule(sender: AnyObject) {
        performSegueWithIdentifier("showDaySelected", sender: self)
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
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    func getCurrentSettings()
    {
        //if nothing archived at file path or nothing scheduled do default (all, 1)
    }
    
    func getNewSettingOnDiff()
    {
        
    }
    
    func loadMoreArticles()
    {
        
    }
    
    //Need function to trigger refresh when pull down table past top or press refresh icon(need to add)
    //On refresh reset offset back to 0


}

