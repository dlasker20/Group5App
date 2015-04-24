//
//  Schedule.swift
//  Group5App
//
//  Created by Lorenzo Parks on 4/16/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

class Schedule: NSObject, NSCoding {
   
    //Properties
    var days: [String]
    var time: NSDate
    var topicSet: String
    var typeSet: String
    var notifications: Bool
    
    //Initializer
    init(days: [String], time: NSDate, topicSet: String, typeSet: String, notifications: Bool){
        
        //set all properties to passed in values
        self.days = days
        self.time = time
        self.topicSet = topicSet
        self.typeSet = typeSet
        self.notifications = notifications
        
        super.init()
    }
    
    required init(coder decoder: NSCoder) {
        self.days = decoder.decodeObjectForKey("days") as! [String];
        self.time = decoder.decodeObjectForKey("time") as! NSDate;
        self.topicSet = decoder.decodeObjectForKey("topicSet") as! String;
        self.typeSet = decoder.decodeObjectForKey("typeSet") as! String;
        self.notifications = decoder.decodeObjectForKey("notifications") as! Bool;
        
        super.init() // super.init(coder:decoder)
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(days, forKey: "days")
        encoder.encodeObject(time, forKey: "time")
        encoder.encodeObject(topicSet, forKey: "topicSet")
        encoder.encodeObject(typeSet, forKey: "typeSet")
        encoder.encodeObject(notifications, forKey: "notifications")
    }
}
