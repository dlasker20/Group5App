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
    
    let refreshControl = UIRefreshControl()
    
    
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
    
    //article to be sent to web view
    var selectedArticle:Article? = nil
    
    //cache for downloaded images
    var imageCache = [String : UIImage]()
    
    override func viewDidAppear(animated: Bool) {
        getArticles(false, showIndicator: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tell table to use custom cell described in CustomTableViewCell.xib
        
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        articleTableView.registerNib(nib, forCellReuseIdentifier: customReuse)
        
        articleTableView.tableFooterView = UIView(frame: CGRectZero)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        articleTableView.addSubview(refreshControl)
        
        getArticles(true, showIndicator: true)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parseConnect.articles.count + 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(parseConnect.articles.count == indexPath.row)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("footer", forIndexPath: indexPath) as! FooterTableViewCell
            
            cell.selectionStyle = .None
            
            
            var footerAccess = cell as FooterTableViewCell
            
            if(parseConnect.articles.count == 0)
            {
                footerAccess.footerLabel.text = "No articles found matching current schedule"
            }
            else
            {
                footerAccess.footerLabel.text = "You are all caught up on " + "technology" + " news!"
            }
            
            return cell
        }
        else{
        let cell = tableView.dequeueReusableCellWithIdentifier(customReuse, forIndexPath: indexPath) as! CustomTableViewCell
        
        self.articleTableView.estimatedRowHeight = 96
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
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(parseConnect.articles.count != indexPath.row)
        {
            selectedArticle = parseConnect.articles[indexPath.row]
            performSegueWithIdentifier(webViewSegue, sender: self)
        }
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
        container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
        
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1)
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
    
    func isNewSchedule()->Bool
    {
        //also set to new schedule if true
        return true
    }
    
    func getArticles(loadNew: Bool, showIndicator: Bool)
    {
        //if old schedule diff(set as global) from new then do a refresh and set global as new
        
        //if nothing archived at file path or nothing scheduled do default (all, 1)
        let daysOld = "7"
        let topic = "all-sections"
        let urlString = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/" + topic + "/" + daysOld + ".json?api-key=b32dcf0a887c83fe37220653ad10c91b:8:71573066"
        
        let path = fileInDocumentsDirectory("schedule.plist")
        var checkValidation = NSFileManager.defaultManager()
        
        //Array to hold schedule
        var mySchedule:NSMutableArray = NSMutableArray()
        
        if(checkValidation.fileExistsAtPath(path))
        {
            mySchedule = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
        }
        
        let todaysDay = getToday()
        //function to get object with closest time
        for(var i = 0; i < mySchedule.count; i++)
        {
            for(var j = 0; j < (mySchedule[i] as! Schedule).days.count; j++)
            {
                if()
                {
                    if()
                    {
                        
                    }
                }
            }
        }
       
        if(showIndicator)
        {
           showActivityIndicator(self.view)
        }
        
        //only on refresh or loading new articles when come back from day selected and difference
        parseConnect.articles.removeAll()
        
        parseConnect.load(urlString) {
            (companies, errorString) -> Void in
            if let unwrappedErrorString = errorString {
                self.hideActivityIndicator(self.view)
                var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            } else {
                self.hideActivityIndicator(self.view)
                self.articleTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
                self.articleTableView.beginUpdates()
                self.articleTableView.endUpdates()
                
            }
        }
    }
    
    
    func refresh()
    {
        dispatch_async(dispatch_get_main_queue()) {
            self.getArticles(true, showIndicator: false)
            self.refreshControl.endRefreshing()
        }
    }
    
    //Get Today's Date
    func getToday()->String {
        let days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
        let weekDay = myComponents.weekday
        return days[weekDay-1]
    }
    
    //Documents Directory (LP)
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        return documentsFolderPath
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }



}

