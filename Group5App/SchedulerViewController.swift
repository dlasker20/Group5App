//
//  SchedulerViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    let topics = ["Arts","Sports","Technology"]
    
    let types = ["National","Short"]
    
    var daysSet = Array(count: 7, repeatedValue: false)
    
    let topicsPicker = 0
    let typesPicker = 1
    
    var daysPickedDetail:UITableViewCell?
    let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let daysAbrev = ["Mon","Tues","Weds","Thurs","Fri","Sat","Sun"]
    
    
    var prevViewController = ""
    
    var mySchedule: Schedule?
    var path: String! //file path for saving data (LP)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Path (LP)
        path = fileInDocumentsDirectory("schedule.plist")
        
        //Load data from saved file on view load (LP)
        if let schedule = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! Schedule? {
            
            //add to UI
            
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
                return 2
            
            case 1:
                return 2
            
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
                    
                    default:
                        cell = tableView.dequeueReusableCellWithIdentifier("pickTime", forIndexPath: indexPath) as! UITableViewCell
                }
            
            case 1:
                switch indexPath.row
                {
                    case 0:
                        cell = tableView.dequeueReusableCellWithIdentifier("topicTypeTitle", forIndexPath: indexPath) as! UITableViewCell
                    
                    default:
                        cell = tableView.dequeueReusableCellWithIdentifier("topicTypeCell", forIndexPath: indexPath) as! UITableViewCell
                }
            
            default:
                switch indexPath.row
                {
                    
                    default:
                        cell = tableView.dequeueReusableCellWithIdentifier("notifyCell", forIndexPath: indexPath) as! UITableViewCell
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
            performSegueWithIdentifier("backToDaySelected", sender: self)
        }
        else
        {
            performSegueWithIdentifier("backToDays", sender: self)
        }
    }
    
    //Function to create schedule object form UI
    func createScheduleFromUI()-> Schedule? {
        var schedule: Schedule? = nil
        
        //schedule = Schedule(days: days, time: time, topic: topic, type: type)
        
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
        
        if let schedule = mySchedule {
            success = NSKeyedArchiver.archiveRootObject(schedule, toFile:path)
            
            if success {
                println("Saved successfully")
            } else {
                println("Error saving data file")
            }
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
        if(daysSet[0] && daysSet[1] && daysSet[2] && daysSet[3] && daysSet[4] && daysSet[5] && daysSet[6])
        {
            daysPickedDetail?.detailTextLabel?.text = "Everyday"
        }
        else if(daysSet[0] && daysSet[1] && daysSet[2] && daysSet[3] && daysSet[4] && !daysSet[5] && !daysSet[6])
        {
            daysPickedDetail?.detailTextLabel?.text = "Weekdays"
        }
        else if(!daysSet[0] && !daysSet[1] && !daysSet[2] && !daysSet[3] && !daysSet[4] && daysSet[5] && daysSet[6])
        {
            daysPickedDetail?.detailTextLabel?.text = "Weekends"
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
                 daysPickedDetail?.detailTextLabel?.text = days[index]
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
                
                daysPickedDetail?.detailTextLabel?.text = abrevString
            }
        }
        
        
    }
    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //send data back to daySelected or days or send nothing back if cancel
    }

}
