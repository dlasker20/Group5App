//
//  SchedulerViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let topics = ["Arts","Sports","Technology","Science"]
    
    let types = ["National","Short"]
    
    var daysSet = Array(count: 7, repeatedValue: false)
    
    let topicsPicker = 0
    let typesPicker = 1
    
    let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let daysAbrev = ["Mon","Tues","Weds","Thurs","Fri","Sat","Sun"]
    
    
    var prevViewController = ""
    
    var showTimePicker = false
    var showTopicTypePicker = false
    
    
    var mySchedule:NSMutableArray = NSMutableArray()
    
    var path: String! //file path for saving data (LP)
    
    //Cell Variables
    var daysPickedDetail: UITableViewCell?
    var datePickerCell: DatePickerTableViewCell?
    var picker: PickerTableViewCell?
    var notify: SwitchTableViewCell?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Path (LP)
        path = fileInDocumentsDirectory("schedule.plist")
        
        //Load data from saved file on view load (LP)
        //DON'T UNARCHIVE UNLESS Day and Time sent
        //don't set if nothing set/sent for day or time
        //(Touch hour aka edit)Get days from array since can have groups (everday,weekdays,weekend). Delete all appointments based on origional data and create new appointments with new data. Create groups if more than 1 in days array but also make additional groups weekend, weekdays, and everyday based of these groups this will require adding day to appointment if similar one already exists....
        var checkValidation = NSFileManager.defaultManager()
        if(checkValidation.fileExistsAtPath(path))
        {
            mySchedule = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
        }
        
        //Test to see if stuff saved correctly
        for(var i = 0; i < mySchedule.count; i++)
        {
            let appointment = mySchedule[i] as! Schedule
             println(appointment.topicSet)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Table view stuff
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
            case 0:
                if(showTimePicker){
                    return 3
                }
                else{
                    return 2
                }
        
            case 1:
                if(showTopicTypePicker){
                    return 2
                }
                else{
                    return 1
                }
            
            default:
                return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        switch indexPath.section
        {
            case 0:
                switch indexPath.row
                {
                    case 0:
                        cell = tableView.dequeueReusableCellWithIdentifier("pickDay", forIndexPath: indexPath) as! UITableViewCell
                    
                        daysPickedDetail = cell
                    
                        setDays()
                    
                        //need to change to day actually sent
                        //if coming from days set day to one that has not been set yet. On the days viewController make sure to throw error before coming here if try to add more than 7 days
                        //set to default if day or time not sent
                    
                    
                    default:
           
                        cell = tableView.dequeueReusableCellWithIdentifier("pickTime", forIndexPath: indexPath) as! DatePickerTableViewCell
                        
                        datePickerCell = cell as? DatePickerTableViewCell
                        
                        //SET DATE TO SAME DATE IN THE PAST SO IT SORTS BY TIME
                        //need to change to date/time actually sent
                        //set to default if day or time not sent
                        (cell as! DatePickerTableViewCell).datePicker.date = NSDate()
                }
            
            case 1:
                switch indexPath.row
                {
                    case 0:
                        cell = tableView.dequeueReusableCellWithIdentifier("topicTypeTitle", forIndexPath: indexPath) as! UITableViewCell
                    
                    default:
                        cell = tableView.dequeueReusableCellWithIdentifier("topicTypeCell", forIndexPath: indexPath) as! PickerTableViewCell
                    
                        picker = cell as? PickerTableViewCell
                    
                        //Need to set topic and type based of day and time sent
                        //set to default if day or time not sent
                    
                    
                }
            
            default:
                switch indexPath.row
                {
                    
                    default:
                        cell = tableView.dequeueReusableCellWithIdentifier("notifyCell", forIndexPath: indexPath) as! SwitchTableViewCell
                    
                        notify = cell as? SwitchTableViewCell
                    
                    
                        //Need to set notifications based of day and time sent
                        //set to default if day or time not sent
                }
        }

        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            performSegueWithIdentifier("showDayPicker", sender: self)
        }
        else if( indexPath.section == 1 && indexPath.row == 0)
        {
            if(showTopicTypePicker)
            {
                showTopicTypePicker = false
                dispatch_async(dispatch_get_main_queue(), {
                    tableView.beginUpdates()
                    tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: .Fade)
                    tableView.endUpdates()
                    
                    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                
                })
                

            }
            else
            {
                showTopicTypePicker = true
                dispatch_async(dispatch_get_main_queue(), {
                    tableView.beginUpdates()
                    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: .Fade)
                    tableView.endUpdates()
                    
                    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                })

            }
            
        }

    }
    
    //Picker View stuff
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(component == topicsPicker)
        {
            return topics.count
        }
        else
        {
            return types.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(component == topicsPicker)
        {
            return topics[row]
        }
        else
        {
            return types[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(component == topicsPicker)
        {
            
        }
        else
        {
            
        }
        
    }

    //No data sent back since just a cancel
    @IBAction func cancel(sender: AnyObject) {
        if(prevViewController == "daySelected")
        {
            performSegueWithIdentifier("returnToDaySelectedFromCancel", sender: self)
        }
        else
        {
            performSegueWithIdentifier("returnToDaysFromCancel", sender: self)
        }
    }
    
    //Function to create schedule object form UI
    func createScheduleFromUI()-> Schedule? {
        
        var schedule: Schedule? = nil
        
        var topicCheck = 0
        var typeCheck = 0
        if let pickerValue = picker{
            topicCheck = pickerValue.topicNTypePickerView.selectedRowInComponent(0)
            typeCheck = pickerValue.topicNTypePickerView.selectedRowInComponent(1)
        }
        
        let topicSet = topics[topicCheck]
        
        let typeSet = types[typeCheck]
        
        var daysSelected = [String]()
        for ( var i = 0; i < 7; i++){
            if(daysSet[i]){
               daysSelected.append(days[i])
            }
        }
    
        let date = datePickerCell!.datePicker.date
        
        let notifySetting = notify!.notifySwitch.on
        
        schedule = Schedule(days: daysSelected, time: date, topicSet: topicSet, typeSet: typeSet, notifications: notifySetting)
        
        return schedule
    }
    
    //Documents Directory (LP)
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        return documentsFolderPath
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }
    
    //Data needs to be sent back
    @IBAction func save(sender: AnyObject) {
        //NSkeyedArchiver (LP)
        
        //path-> documents directory (LP)
        println("save: \(path)")
        
        var success = false
        
        mySchedule.addObject(createScheduleFromUI()!)
        
        success = NSKeyedArchiver.archiveRootObject(mySchedule, toFile:path)
            
        if success {
            println("Saved successfully")
        } else {
            println("Error saving data file")
        }
        
        if(prevViewController == "daySelected")
        {
            performSegueWithIdentifier("backToDaySelected", sender: self )
        }
        else
        {
            performSegueWithIdentifier("backToDays", sender: self)
        }
    }

    
    @IBAction func returnToScheduler(segue: UIStoryboardSegue) {
        setDays()
    }
    
    func setDays()
    {
        if(daysSet[0] && daysSet[1] && daysSet[2] && daysSet[3] && daysSet[4] && daysSet[5] && daysSet[6])
        {
            daysPickedDetail!.detailTextLabel?.text = "Everyday"
        }
        else if(daysSet[0] && daysSet[1] && daysSet[2] && daysSet[3] && daysSet[4] && !daysSet[5] && !daysSet[6])
        {
            daysPickedDetail!.detailTextLabel?.text = "Weekdays"
        }
        else if(!daysSet[0] && !daysSet[1] && !daysSet[2] && !daysSet[3] && !daysSet[4] && daysSet[5] && daysSet[6])
        {
            daysPickedDetail!.detailTextLabel?.text = "Weekends"
        }
        else
        {
            var count = 0
            var index = 0
            for(var i = 0; i < 7; i++)
            {
                if(daysSet[i])
                {
                    count++
                    index = i
                }
            }
            
            if(count == 1)
            {
                daysPickedDetail!.detailTextLabel?.text = days[index]
            }
            else
            {
                var abrevString = ""
                for(var i = 0; i < 7; i++)
                {
                    if(daysSet[i])
                    {
                        abrevString = abrevString + " " + daysAbrev[i]
                    }
                }
                
                daysPickedDetail!.detailTextLabel?.text = abrevString
            }
        }
        
    }
    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDayPicker")
        {
            let destinationViewController = segue.destinationViewController as! DayPickerViewController
            for(var i = 0; i < 7; i++)
            {
                destinationViewController.daysSet[i] = daysSet[i]
            }
            
            
        }
    }

}


//TODO: Figure out how to check if record already exist and throw an error on create. Also how to edit and delte record (should make functions for these things and to also send type and topic back to andrew via a function call)

//Display error if no connection to internet and thus cannot get JSON (do on main page and UIWebView)
//loading gif for UIWebView?
//pull down to refresh or refresh icon or both???
//Fix warnings
//how to clear/delete archived file/stuff so that can have a fresh file
//Make sure 1 always checked in day picker

//Better navigation indicators
//Add way to transition/send data to proper view when click on time or when click on a day to edit/view

//Add
//Edit
//ERROR MESSAGE IF CREATE CONFLICTS, SO DON'T ALLOW TO SAVE
//Add to existing appointment day is days with similar settings already exist
//Delete(Should be in daysSelected and Days instead of here???)
//Send type and topic back based on time(Should just create function in Articles controller instead of here???)(Set default like arts if nothing scheduled for day)
//set notifications
//edit notifications when change
//delete notifications when delete(hour or day) or turn off

//Get developer registered so can test on actual iphone and then deploy to store
