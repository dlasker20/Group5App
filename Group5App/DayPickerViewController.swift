//
//  DayPickerViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class DayPickerViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var daysTable: UITableView!
    
    let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var daysSet = Array(count: 7, repeatedValue: false)
    
    //Variable to store cells
    var cells = [UITableViewCell]()
    
    var numCheckmarks = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! UITableViewCell
        
        cells.append(cell)
        
        cell.textLabel?.text = days[indexPath.row]
        
        if(daysSet[indexPath.row])
        {
            cell.accessoryType = .Checkmark
            numCheckmarks++
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if(cell?.accessoryType == .Checkmark)
        {
            if(numCheckmarks > 1)
            {
                cell?.accessoryType = .None
                numCheckmarks--
            }
        }
        else
        {
            cell?.accessoryType = .Checkmark
            numCheckmarks++
        }
    }

    
    
    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! SchedulerViewController
        
        
        for(var i = 0; i < 7; i++)
        {
            if(cells[i].accessoryType == .Checkmark)
            {
                destinationViewController.daysSet[i] = true
            }
            else
            {
                destinationViewController.daysSet[i] = false
            }
        }
    }
}
