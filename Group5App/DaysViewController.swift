//
//  DaysViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class DaysViewController: UIViewController,UITabBarDelegate, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
     var tabBarShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.hidden = true;
        tabBar.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edit(sender: AnyObject) {
        if(self.tabBarShown == false)
        {
            self.tabBar.hidden = false
            self.tabBarShown = true
            self.editButton.title = "Done"
        }
        else
        {
            self.tabBar.hidden = true
            self.tabBarShown = false
            self.editButton.title = "Edit"
        }

    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if(item.title == "Delete")
        {
            
        }
        else
        {
            performSegueWithIdentifier("showScheduler2", sender: self)
        }
    }
    
    //Code for table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "Monday"
        cell.detailTextLabel?.text = "6:00AM 10:00AM 8:15PM 9:00PM 10:00PM 11:00PM 6:00AM 10:00AM 8:15PM 9:00PM 10:00PM 11:00PM"
        
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

    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showScheduler2")
        {
            let destinationViewController = segue.destinationViewController as! SchedulerViewController
            destinationViewController.prevViewController = "days"
        }
        
    }
    
    @IBAction func returnToDays(segue: UIStoryboardSegue) {
        
    }


}
