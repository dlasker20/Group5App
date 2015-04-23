//
//  DaySelectedViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class DaySelectedViewController: UIViewController,UITabBarDelegate, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tabHeight: NSLayoutConstraint!
    
    var tabBarShown = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.hidden = true
        tabBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edit(sender: AnyObject) {
       
            if(self.tabBarShown == false)
            {
                tabHeight.constant = 49
                self.tabBar.hidden = false
                self.tabBarShown = true
                self.editButton.title = "Done"
            }
            else
            {
                tabHeight.constant = 0
                self.tabBar.hidden = true
                self.tabBarShown = false
                self.editButton.title = "Edit"
            }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if(item.title == "Delete")
        {
            
        }
        else if(item.title == "Add")
        {
            performSegueWithIdentifier("showScheduler1", sender: self)
        }
        else
        {
            performSegueWithIdentifier("showDays", sender: self)
        }
    }
    
    //Code for table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.imageView?.image = UIImage(named: "arts")!
        cell.textLabel?.text = "8:15PM"
        cell.detailTextLabel?.text = "Arts"
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if(cell?.accessoryType == .Checkmark)
        {
            cell?.accessoryType = .None
        }
        else
        {
            cell?.accessoryType = .Checkmark
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showScheduler1")
        {
            let destinationViewController = segue.destinationViewController as! SchedulerViewController
            destinationViewController.prevViewController = "daySelected"
        }

        
    }
    
    
    @IBAction func returnToDaySelected(segue: UIStoryboardSegue) {
        
    }


}
