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
    
    let topicsPicker = 0
    let typesPicker = 1
    
    var daysPicked:UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Table view stuff
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
            case 0:
                return 2
            
            case 1:
                return 2
            
            case 2:
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
                        
                        daysPicked = cell
                    
                    default:
                        cell = tableView.dequeueReusableCellWithIdentifier("pickTime", forIndexPath: indexPath) as! UITableViewCell
                }
            
            case 1:
                switch indexPath.row
                {
                    case 0:
                        cell = tableView.dequeueReusableCellWithIdentifier("topicTitle", forIndexPath: indexPath) as! UITableViewCell
                    
                    default:
                        cell = tableView.dequeueReusableCellWithIdentifier("topicCell", forIndexPath: indexPath) as! UITableViewCell
                }
            
            case 2:
                switch indexPath.row
                {
                    case 0:
                        cell = tableView.dequeueReusableCellWithIdentifier("typeTitle", forIndexPath: indexPath) as! UITableViewCell
                
                    default:
                        cell = tableView.dequeueReusableCellWithIdentifier("typeCell", forIndexPath: indexPath) as! UITableViewCell
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

    

    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func returnToScheduler(segue: UIStoryboardSegue) {
        
    }

}
