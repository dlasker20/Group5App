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
    
    var sortLookup: [String: Int] = ["Everyday": -2, "Weekdays": -1, "Weekends": 0, "Monday": 1, "Tuesday": 2, "Wednesday": 4, "Thursday": 8, "Friday": 16, "Saturday": 32, "Sunday": 64]
    
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
        
        var totalDays = NSMutableArray(array: day.days)
        
        
        if(totalDays.containsObject("Monday") && totalDays.containsObject("Tuesday") && totalDays.containsObject("Wednesday") && totalDays.containsObject("Thursday") && totalDays.containsObject("Friday") && totalDays.containsObject("Saturday") && totalDays.containsObject("Sunday") && totalDays.count == 7)
        {
            daysTitle = "Everyday"
        }
        else if(totalDays.containsObject("Monday") && totalDays.containsObject("Tuesday") && totalDays.containsObject("Wednesday") && totalDays.containsObject("Thursday") && totalDays.containsObject("Friday") && totalDays.count == 5)
        {
            daysTitle = "Weekdays"
        }
        else if(totalDays.containsObject("Saturday") && totalDays.containsObject("Sunday") && totalDays.count == 2)
        {
            daysTitle = "Weekends"
        }
        else
        {
            for(var i = 0; i < day.days.count; i++)
            {
                daysTitle = daysTitle + " " + day.days[i]
            }
        }
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        
        var times = ""
        var time: [Schedule] = daysToShow[indexPath.row] as! [Schedule]
        for(var i = 0; i < time.count; i++)
        {
            times = times + " " + formatter.stringFromDate(time[i].time).stringByReplacingOccurrencesOfString(" ", withString: "")
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            for(var i = 0; i < mySchedule.count; i++)
            {
                var sch = (mySchedule[i] as! Schedule)
                for(var j = 0; j < sch.days.count; j++)
                {
                    var day = (daysToShow[indexPath.row][0] as! Schedule)
                    for( var k = 0; k < day.days.count; k++)
                    {
                        if(sch.days[j] == day.days[k])
                        {
                            if(sch.days.count == 1)
                            {
                                mySchedule.removeObjectAtIndex(1)
                            }
                            else
                            {
                                (mySchedule[i] as! Schedule).days.removeAtIndex(j)
                            }
                        }
                    }
                    
                }
            }
            
            daysToShow.removeObjectAtIndex(indexPath.row)
            
             NSKeyedArchiver.archiveRootObject(mySchedule, toFile:path)
            
            deletionComplete = true
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.myTable.reloadData()
                })
            })
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            CATransaction.commit()
            
            
            if(daysToShow.count == 0)
            {
                nothingToShow = true
            }
            
        }
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
            if(daysToShow.count == 0)
            {
                var indivSchedule = (mySchedule[i] as! Schedule)
                if(indivSchedule.days.count > 1)
                {
                    for(var j = 0; j < indivSchedule.days.count; j++)
                    {
                        var toAdd = NSMutableArray()
                        toAdd.addObject(Schedule(days: [indivSchedule.days[j]], time: indivSchedule.time, topicSet: indivSchedule.topicSet, typeSet: indivSchedule.typeSet))
                        daysToShow.addObject(toAdd)
                        
                    }
                }
                var toAdd = NSMutableArray()
                toAdd.addObject(mySchedule[i])
                daysToShow.addObject(toAdd)
            }
            else
            {
                var indivSchedule: Schedule = mySchedule[i] as! Schedule
                var match = false
                var same = false
                var sameAlsoSize = false
                var prevIsLargerSet = false
                var prevIndex = 0

                var schSetRemaining = NSMutableSet(array: indivSchedule.days as [String])
                for(var b = 0; b < daysToShow.count; b++)
                {
                    var daysToShowElement = (daysToShow[b][0] as! Schedule)
                    var daysSet = NSSet(array:daysToShowElement.days as [String])
                    var schSet = NSSet(array: indivSchedule.days as [String])
                    if(daysSet.isSubsetOfSet(schSet as Set<NSObject>) )
                    {
                        daysToShow[b].addObject(indivSchedule)
                        same = true
                        if(daysSet.count == schSet.count)
                        {
                            sameAlsoSize = true
                        }
                    }
                    
                    schSetRemaining.minusSet(daysSet as Set<NSObject>)
                    
                }
                if(same == false)
                {
                    if(indivSchedule.days.count > 1)
                    {
                        for(var c = 0; c < indivSchedule.days.count; c++)
                        {
                            var toAdd = NSMutableArray()
                            toAdd.addObject(Schedule(days: [indivSchedule.days[c]], time: indivSchedule.time, topicSet: indivSchedule.topicSet, typeSet: indivSchedule.typeSet))
                            daysToShow.addObject(toAdd)
                        }
                    }
                    var toAdd = NSMutableArray()
                    toAdd.addObject(indivSchedule)
                    daysToShow.addObject(toAdd)
                }
                else if(schSetRemaining.count > 0 && same)
                {
                    for(var c = 0; c < schSetRemaining.count; c++)
                    {
                        var toAdd = NSMutableArray()
                        var days = Array(schSetRemaining)
                        toAdd.addObject(Schedule(days: [(days[c] as! String)], time: indivSchedule.time, topicSet: indivSchedule.topicSet, typeSet: indivSchedule.typeSet))
                        daysToShow.addObject(toAdd)
                    }
                    
                    var toAdd = NSMutableArray()
                    toAdd.addObject(indivSchedule)
                    daysToShow.addObject(toAdd)
                }
                else if(sameAlsoSize == false)
                {
                    var toAdd = NSMutableArray()
                    toAdd.addObject(indivSchedule)
                    daysToShow.addObject(toAdd)
                }
            }
        }
        
        //Sort all times in each row of daysToShow 2D array(used to show times for day(s) in ascending order)
        for(var i = 0; i < daysToShow.count; i++)
        {
            let timeSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
            let sortedByTime = (daysToShow[i] as! NSMutableArray).sortedArrayUsingDescriptors([timeSortDescriptor])
            daysToShow.replaceObjectAtIndex(i, withObject: sortedByTime)
        }
        
        //daysToShow.sortUsingComparator(<#cmptr: NSComparator##(AnyObject!, AnyObject!) -> NSComparisonResult#>)
        
        //sort by groups (Every,week,end,M,T...groups(will be alphabetical when store)) give enumeration with values and use to determine order by theselves or add up
        
        //DELETION AND THEN DONE
        
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
