//
//  DaysViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class DaysViewController: UIViewController,UITabBarDelegate, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tabHeight: NSLayoutConstraint!
     var tabBarShown = false
    
    //variable to hold days to show
    var daysToShow:NSMutableArray = NSMutableArray()
    
    var path: String! //file path for saving data (LP)
    var mySchedule:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        myTable.editing = false
        
        myTable.tableFooterView = UIView(frame: CGRectZero)
        
        //load in data
        path = fileInDocumentsDirectory("schedule.plist")
        var checkValidation = NSFileManager.defaultManager()
        if(checkValidation.fileExistsAtPath(path))
        {
            mySchedule = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
        }
        
        getDays()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edit(sender: AnyObject) {
        if(myTable.editing == false)
        {
            //tabHeight.constant = 49
            //self.tabBar.hidden = false
            //self.tabBarShown = true
            self.editButton.title = "Done"
            myTable.editing = true
        }
        else
        {
            //tabHeight.constant = 0
            //self.tabBar.hidden = true
            //self.tabBarShown = false
            self.editButton.title = "Edit"
            myTable.editing = false
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
        return 15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "Monday"
        cell.detailTextLabel?.text = "6:00AM 10:00AM 8:15PM 9:00PM 10:00PM 11:00PM 6:00AM 10:00AM 8:15PM 9:00PM 10:00PM 11:00PM"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("returnToDaySelectedFromDays", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showScheduler2")
        {
            let destinationViewController = segue.destinationViewController as! SchedulerViewController
            destinationViewController.prevViewController = "days"
        }
        else
        {
            let destinationViewController = segue.destinationViewController as! DaySelectedViewController
            //destinationViewController.sentDays = daysToShow
            destinationViewController.sentDays = ["Monday","Tuesday"]
        }
        
    }
    
    //Data saved
    @IBAction func returnToDays(segue: UIStoryboardSegue) {
        
    }
    
    //Canceled Scheduler
    @IBAction func returnToDaysFromCancel(segue: UIStoryboardSegue) {
        
    }
    
    
    //Functions for data
    func getDays()
    {
        /*var weekDays = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
        var weekEnds = ["Saturday","Sunday"]
        for(var i = 0; i < mySchedule.count; i++)
        {
             //TODO:SORT
            var appointment = mySchedule[i] as! Schedule
            var appointmentSet = NSSet(array: appointment.days as [AnyObject])
            if(sentDaysSet.isSubsetOfSet(appointmentSet as Set<NSObject>) || appointmentSet.isSubsetOfSet(sentDaysSet as Set<NSObject>))
            {
                daysToShow.addObject(appointment)
                //daysToShow = daysToSend.sortUsingComparator([$0.time < $1.time])
            }
            //Checks for Everyday
            if(appointmentSet.count == 7)
            {
                daysToShow.addObject(appointment)
            }
            
        }*/
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
