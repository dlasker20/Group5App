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
    var daysToShow: NSMutableArray = NSMutableArray()
    
    var path: String! //file path for saving data (LP)
    var mySchedule:NSMutableArray = NSMutableArray()
    
    var selectedDayData = NSMutableArray()
    
    var nothingToShow = false
    var deletionComplete = false
    var allowEdit = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        getSchedule()
        getDays()
        
        myTable.tableFooterView = UIView(frame: CGRectZero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edit(sender: AnyObject) {
        if(allowEdit)
        {
            if(myTable.editing == false)
            {
                self.editButton.title = "Done"
                myTable.editing = true
            }
            else
            {
                self.editButton.title = "Edit"
                myTable.editing = false
            }
        }

    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        
        performSegueWithIdentifier("showScheduler2", sender: self)
    }
    
    //Code for table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(deletionComplete)
        {
            deletionComplete = false
            allowEdit = true
            return daysToShow.count
            
        }
        else if(daysToShow.count == 0)
        {
            nothingToShow = true
            allowEdit = false
            self.editButton.title = "Edit"
            myTable.editing = false
            return daysToShow.count + 1
        }
        allowEdit = true
        return daysToShow.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(nothingToShow)
        {
            nothingToShow = false
            
            let cell = tableView.dequeueReusableCellWithIdentifier("noDaysScheduled", forIndexPath: indexPath) as! UITableViewCell
            
            cell.selectionStyle = .None
            
            return cell
        }

        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! UITableViewCell
            
        var daysTitle = ""
        
        var day = daysToShow[indexPath.row][0] as! Schedule
        
        for(var i = 0; i < day.days.count; i++)
        {
            daysTitle = daysTitle + " " + day.days[i]
        }
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        
        var times = ""
        var time: [Schedule] = daysToShow[indexPath.row] as! [Schedule]
        for(var i = 0; i < time.count; i++)
        {
            times = times + " " + formatter.stringFromDate(time[i].time).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
        }
        
        cell.textLabel?.text = daysTitle
        cell.detailTextLabel?.text = times
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(daysToShow.count > 0)
        {
            selectedDayData.removeAllObjects()
            var days = (daysToShow[indexPath.row][0] as! Schedule).days
            for(var i = 0; i < days.count; i++)
            {
                selectedDayData.addObject(days[i])
                
            }
            performSegueWithIdentifier("returnToDaySelectedFromDays", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showScheduler2")
        {
            let destinationViewController = segue.destinationViewController as! SchedulerViewController
            destinationViewController.prevViewController = "days"
            destinationViewController.daysSet[0] = true
        }
        else
        {
            let destinationViewController = segue.destinationViewController as! DaySelectedViewController
            destinationViewController.sentDays = selectedDayData
            destinationViewController.isToday = false
        }
        
        myTable.editing = false
        self.editButton.title = "Edit"
        
    }
    
    //Data saved
    @IBAction func returnToDays(segue: UIStoryboardSegue) {
        reRunStuff()
        
    }
    
    //Canceled Scheduler
    @IBAction func returnToDaysFromCancel(segue: UIStoryboardSegue) {
        reRunStuff()
    }
    
    func reRunStuff()
    {
        getSchedule()
        
        getDays()
        
        dispatch_async(dispatch_get_main_queue(), {
            self.myTable.reloadData()
        })
    }
    
    //Get schedule
    func getSchedule()
    {
        path = fileInDocumentsDirectory("schedule.plist")
        var checkValidation = NSFileManager.defaultManager()
        if(checkValidation.fileExistsAtPath(path))
        {
            mySchedule = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
        }
        
    }
    
    //Write get days
    //write function to sort days
    //show days in order (Every,week,end,M,T...groups(will be alphabetical when store))
    //show times in ascending order
    //show message if none
    //send day to add(could be next available or just default???)
    //delete day
    //checkmark days with active times or today???
    
    //Functions for data
    func getDays()
    {
        daysToShow.removeAllObjects()
        
        for(var i = 0; i < mySchedule.count; i++)
        {
            var same = false
            if(daysToShow.count == 0)
            {
                var toAdd = NSMutableArray()
                toAdd.addObject(mySchedule[i])
                daysToShow.addObject(toAdd)
            }
            else
            {
                for(var j = 0; j < daysToShow.count; j++)
                {
                    println(j)
                    var count = 0
                    var indivSchedule: Schedule = mySchedule[i] as! Schedule
                    
                    var daysToShowElement = (daysToShow[j][0] as! Schedule)
                    
                    for(var k = 0; k < indivSchedule.days.count; k++)
                    {
                        for(var z = 0; z < daysToShowElement.days.count; z++)
                        {
                            if(indivSchedule.days[k] == daysToShowElement.days[z])
                            {
                                count++
                            }
                        }
                    }
                    if(count == indivSchedule.days.count && indivSchedule.days.count == daysToShowElement.days.count)
                    {
                        println("HI")
                        daysToShow[j].addObject(indivSchedule)
                    }
                    else
                    {
                        println("BYE")
                        var toAdd = NSMutableArray()
                        toAdd.addObject(indivSchedule)
                        daysToShow.addObject(toAdd)
                    }
                }
            }
        }
        
        //order by time for loop through days to show and sort by ascending
        
        //sort by groups (Every,week,end,M,T...groups(will be alphabetical when store)) give enumeration with values and use to determine order by theselves or add up
        
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
