//
//  SchedulerViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class SchedulerViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    

    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    @IBAction func returnToScheduler(segue: UIStoryboardSegue) {
        
    }

}
