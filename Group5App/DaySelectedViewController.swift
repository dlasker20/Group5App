//
//  DaySelectedViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class DaySelectedViewController: UIViewController,UITabBarDelegate, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var myTable: UITableView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tabHeight: NSLayoutConstraint!
    
    let refreshControl = UIRefreshControl()
    
    //variable to hold sent days
    var sentDays:NSMutableArray = NSMutableArray()
    
    //variable to hold times to show
    var timesToShow:NSMutableArray = NSMutableArray()
    
    var path: String! //file path for saving data (LP)
    var mySchedule:NSMutableArray = NSMutableArray()
    
    var scheduleInUse: Int?
    
    var nothingToShow = false
    var deletionComplete = false
    
    var allowEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        //self.tabBar.hidden = true
        
        myTable.editing = false
        
        //load in data
        getSchedule()
        
        //Set title
        setTitle()
        
        //get times
        getTimes()
        
        myTable.tableFooterView = UIView(frame: CGRectZero)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        myTable.addSubview(refreshControl)

    }
    
    override func viewDidAppear(animated: Bool) {
        checkMarkInUse()
        dispatch_async(dispatch_get_main_queue(), {
            self.myTable.reloadData()
        })

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
        if(item.title == "Add")
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
        
        if(deletionComplete)
        {
            deletionComplete = false
            allowEdit = true
            return timesToShow.count
            
        }
        else if(timesToShow.count == 0)
        {
            nothingToShow = true
            allowEdit = false
            self.editButton.title = "Edit"
            myTable.editing = false
            return timesToShow.count + 1
        }
        allowEdit = true
        return timesToShow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(nothingToShow)
        {
            nothingToShow = false
            
            let cell = tableView.dequeueReusableCellWithIdentifier("nothingScheduled", forIndexPath: indexPath) as! UITableViewCell
            
            cell.selectionStyle = .None
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("timeCell", forIndexPath: indexPath) as! UITableViewCell
        
        var appointment = timesToShow[indexPath.row] as! Schedule
        
        cell.imageView?.image = UIImage(named:appointment.topicSet)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        cell.textLabel?.text = formatter.stringFromDate(appointment.time)
        
        cell.detailTextLabel?.text = appointment.topicSet
        
        if(scheduleInUse != nil)
        {
            if(scheduleInUse == indexPath.row)
            {
                cell.accessoryType = .Checkmark
                cell.editingAccessoryType = .Checkmark
            }
            else
            {
                cell.accessoryType = .None
                cell.editingAccessoryType = .None
            }
        }
        else
        {
            cell.accessoryType = .None
            cell.editingAccessoryType = .None
        }
    
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var removeObjIndex = mySchedule.indexOfObjectIdenticalTo(timesToShow[indexPath.row])
            var removeObj: Schedule = mySchedule[removeObjIndex] as! Schedule
    
            var stillExists = true
            for (var i = 0; i < sentDays.count; i++)
            {
                for(var j = 0; j < removeObj.days.count; j++)
                {

                    if(sentDays[i].isEqual(removeObj.days[j]))
                    {
                        if(removeObj.days.count == 1)
                        {
                            mySchedule.removeObjectAtIndex(removeObjIndex)
                            stillExists = false
                        }
                        else
                        {
                            removeObj.days.removeAtIndex(j)
                        }
                    }
                }
            }
            
            if(stillExists)
            {
                mySchedule.replaceObjectAtIndex(removeObjIndex, withObject: removeObj)
            }
            
            timesToShow.removeObjectAtIndex(indexPath.row)
           
            NSKeyedArchiver.archiveRootObject(mySchedule, toFile:path)
            
            checkMarkInUse()
            
            deletionComplete = true
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.myTable.reloadData()
                })
            })
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            CATransaction.commit()
            
            
            if(timesToShow.count == 0)
            {
                nothingToShow = true
            }

        }
    }
    
    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showScheduler1")
        {
            let destinationViewController = segue.destinationViewController as! SchedulerViewController
            destinationViewController.prevViewController = "daySelected"
            
            if(sentDays.containsObject("Monday"))
            {
                destinationViewController.daysSet[0] = true
            }
            if(sentDays.containsObject("Tuesday"))
            {
                destinationViewController.daysSet[1] = true
            }
            if(sentDays.containsObject("Wednesday"))
            {
                destinationViewController.daysSet[2] = true
            }
            if(sentDays.containsObject("Thursday"))
            {
                destinationViewController.daysSet[3] = true
            }
            if(sentDays.containsObject("Friday"))
            {
                destinationViewController.daysSet[4] = true
            }
            if(sentDays.containsObject("Saturday"))
            {
                destinationViewController.daysSet[5] = true
            }
            if(sentDays.containsObject("Sunday"))
            {
                destinationViewController.daysSet[6] = true
            }
            
        }
    
        //TODO: editing one need to set object of Schedule selected

        myTable.editing = false
        self.editButton.title = "Edit"
        
    }
    
    //Canceled scheduler
    @IBAction func returnToDaySelectedFromCancel(segue: UIStoryboardSegue) {
        checkMarkInUse()
        dispatch_async(dispatch_get_main_queue(), {
            self.myTable.reloadData()
        })
    }
    
    
    //Saved Data
    @IBAction func returnToDaySelected(segue: UIStoryboardSegue) {
        setTitle()
        getSchedule()
        getTimes()
        dispatch_async(dispatch_get_main_queue(), {
            self.myTable.reloadData()
        })
    }
    
    //Selected new day(s)
    @IBAction func returnToDaySelectedFromDays(segue: UIStoryboardSegue) {
        setTitle()
        getSchedule()
        getTimes()
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
    
    //Set title
    func setTitle()
    {
        if(sentDays.count == 0)
        {
                self.title = "Today"
                sentDays = [getToday()]
        }
        else if(sentDays.count == 1 && sentDays[0] as! String == getToday())
        {
            sentDays.removeAllObjects()
            sentDays = [getToday()]
        }
        else
        {
            var title = ""
            for(var i = 0; i < sentDays.count; i++)
            {
                title = title + " " + (sentDays[i] as! String)
            }
            self.title = title
        }
    }
    
    //Functions for data
    func getTimes()
    {
        timesToShow.removeAllObjects()
        var sentDaysSet = NSSet(array: sentDays as [AnyObject])
        for(var i = 0; i < mySchedule.count; i++)
        {
            var appointment = mySchedule[i] as! Schedule
            var appointmentSet = NSSet(array: appointment.days as [AnyObject])
            if(sentDaysSet.isSubsetOfSet(appointmentSet as Set<NSObject>))
            {
                timesToShow.addObject(appointment)
                
                //Sorting in ascending order by time
                let timeSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
                let sortedByTime = (timesToShow as NSMutableArray).sortedArrayUsingDescriptors([timeSortDescriptor])
                
                timesToShow.removeAllObjects()
                
                timesToShow.addObjectsFromArray(sortedByTime)
            }
        }
        
       checkMarkInUse()

    }
    
    func checkMarkInUse()
    {
        //Checkmark schdule in use
        scheduleInUse = nil
        
        let currentRawDateCurrent = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(currentRawDateCurrent)
        let currentTime = formatter.dateFromString(timeString)
        
        var bestSchedule: Schedule?
        
        for(var i = 0; i < timesToShow.count; i++)
        {
            
            if(timesToShow[i].time.compare(currentTime!) != NSComparisonResult.OrderedDescending)
            {
                if (bestSchedule != nil){
                    if(timesToShow[i].time.compare(bestSchedule!.time) == NSComparisonResult.OrderedDescending)
                    {
                        bestSchedule = timesToShow[i] as? Schedule
                        scheduleInUse = i
                    }
                }
                else
                {
                    bestSchedule = timesToShow[i] as? Schedule
                    scheduleInUse = i
                }
            }
            
        }
    }
    
    func refresh()
    {
        checkMarkInUse()
        dispatch_async(dispatch_get_main_queue()) {
            self.myTable.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    //Documents Directory (LP)
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        return documentsFolderPath
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
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


}
