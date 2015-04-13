//
//  DaySelectedViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class DaySelectedViewController: UIViewController,UITabBarDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var tabBarShown = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.hidden = true;
        tabBar.delegate = self
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

    @IBAction func returnToDaySelected(segue: UIStoryboardSegue) {
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if(item.title == "Delete")
        {
            
        }
        else if(item.title == "Add")
        {
            performSegueWithIdentifier("showScheduler1", sender: self)
        }
        else
        {
            performSegueWithIdentifier("showDays", sender: self)
        }
    }

}
