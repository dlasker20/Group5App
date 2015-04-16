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
        /*parseConnect.connectNow()
        println("parseConnect.connectNow called")
        articleTableView.reloadData()
        */
        /*if(parseConnect.articles[0].title != nil){
            articleTableView.reloadData()
        }*/
        
        //tell table to use custom cell described in CustomTableViewCell.xib
        var nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        articleTableView.registerNib(nib, forCellReuseIdentifier: customReuse)
        
        parseConnect.load(urlString) {
            (companies, errorString) -> Void in
            if let unwrappedErrorString = errorString {
                // can do something about error here
                println(unwrappedErrorString)
            } else {
                self.articleTableView.reloadData()
            }
        }
        
    }
    
    //table functions that need to be wired up to the parsed JSON data
    
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

        
        var rnum = 1+(arc4random()%4)
        let pic = UIImage(named: "dummy\(rnum)")
        
        
        
        cell.cellImage?.image = pic
        cell.cellHeadline?.text = parseConnect.articles[indexPath.row].title
        cell.cellDetail?.text = parseConnect.articles[indexPath.row].section
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedArticle = parseConnect.articles[indexPath.row]
        performSegueWithIdentifier(webViewSegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == webViewSegue){
            let destinationViewController = segue.destinationViewController as! WebViewController
            destinationViewController.article = selectedArticle
        }
    }
    
    //putting in this IBAction function gives interface builder somewhere to look when I connect the back button
    //to the exit segue it knows where to send the app
    @IBAction func exitSeg(sender:UIStoryboardSegue){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func schedule(sender: AnyObject) {
        performSegueWithIdentifier("showDaySelected", sender: self)
    }
    
    @IBAction func returnToArticles(segue: UIStoryboardSegue) {
        
    }
    

}

//Questions/TODOS
//1) unwind 1 button to 2 differnt spots selected day or days when cancel/save from scheduler (currently just have an exit segue on cancel/save with an id that goes back to day selected) *causes something to get printed actually
//2) Layout constraints for scheduler and how to get to show up
//3) Hide tab bar after certain actions/segues?
//4) Make table cells selectable to delete
//6) How to get all nav view controller stuff to say back
//7) remove print statements
//8) Set up NSKeyArchiver and figure out what need to store
//9) Figure out what data I need to pass to Lorenzo and what he needs to pass back to me
//10) Loading gif when articles loading in. Also show and load in new when pull down to a certain point
//11)Topic and type in one cell for simplicity and to save space???
