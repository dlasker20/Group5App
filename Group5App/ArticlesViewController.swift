//
//  ArticlesViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    
    @IBOutlet weak var articleTableView: UITableView!
    
    //declare instance of parser class
    let parseConnect = parser()
    //declare reuseidentifier as constant
    let reuseidentifier = "articleCell"
    let webViewSegue = "showStory"
    
    let urlString = "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/Arts/1.json?api-key=b32dcf0a887c83fe37220653ad10c91b:8:71573066"
    
    //article to be sent to web view
    var selectedArticle:Article? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*parseConnect.connectNow()
        println("parseConnect.connectNow called")
        articleTableView.reloadData()
        */
        /*if(parseConnect.articles[0].title != nil){
            articleTableView.reloadData()
        }*/
        
        println("view did load")
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseidentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = parseConnect.articles[indexPath.row].title
        cell.detailTextLabel?.text = parseConnect.articles[indexPath.row].section
        
        return cell
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
//1) unwind 1 button to 2 differnt spots selected day or days when cancel from scheduler (currently just
//   have an exit segue on cancel with an id that goes back to day selected)
//2) Layout constraints for scheduler and how to get to show up
//3) Hide tab bar after certain actions/segues
//4) Make table cells selectable to delete
//5) Icons or words
//6) How to get all nav view controller stuff to say back
