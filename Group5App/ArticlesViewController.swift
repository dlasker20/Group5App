//
//  ArticlesViewController.swift
//  Group5App
//
//  Created by Dan Lasker on 4/10/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func schedule(sender: AnyObject) {
        performSegueWithIdentifier("showDaySelected", sender: self)
    }
    
    //Logic to send data to different views via segues and their specific ids
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
    @IBAction func returnToArticles(segue: UIStoryboardSegue) {
        
    }
    

}

//Questions/TODOS
//1) unwind 1 button to 2 differnt spots selected day or days when cancel from scheduler (currently just
//   have an exit segue on cancel with an id that goes back to day selected)
//2) Layout constraints for scheduler and how to get to show up
//3) Hide tab bar after certain actions/segues
//4) Make table cells selectable to delete
//5) Icons or words
//6) How to get all nav view controller stuff to say back
