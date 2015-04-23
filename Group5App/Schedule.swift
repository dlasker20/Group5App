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
    var time: String
    var topic: String
    var type: String
    var notifications: Bool
    
    //Initializer
    init(days: [String], time: String, topic: String, type: String, notifications: Bool){
        
        //set all properties to passed in values
        self.days = days
        self.time = time
        self.topic = topic
        self.type = type
        self.notifications = notifications
        
        super.init()
    }
    
    required init(coder decoder: NSCoder) {
        self.days = decoder.decodeObjectForKey("days") as! [String];
        self.time = decoder.decodeObjectForKey("time") as! String;
        self.topic = decoder.decodeObjectForKey("topic") as! String;
        self.type = decoder.decodeIntegerForKey("type") as! String;
        self.notifications = decoder.decodeBoolForKey("notifications") as! Bool;
        
        super.init() // super.init(coder:decoder)
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        
        encoder.encodeObject(days, forKey: "days")
        encoder.encodeObject(time, forKey: "time")
        encoder.encodeObject(topic, forKey: "topic")
        encoder.encodeObject(type, forKey: "type")
        encoder.encodeObject(notifications, forKey: "notifications")
    }
}
