//
//  AppDelegate.swift
//  Group5App
//
//  Created by Dan Lasker on 4/4/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    var mySchedule:NSMutableArray = NSMutableArray()



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch.
        
        // Actions
        var firstAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "FIRST_ACTION"
        firstAction.title = "First Action"
        
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        var secondAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "SECOND_ACTION"
        secondAction.title = "Second Action"
        
        secondAction.activationMode = UIUserNotificationActivationMode.Foreground
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        var thirdAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        thirdAction.identifier = "THIRD_ACTION"
        thirdAction.title = "Third Action"
        
        thirdAction.activationMode = UIUserNotificationActivationMode.Background
        thirdAction.destructive = false
        thirdAction.authenticationRequired = false
        
        
        // category
        var firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        
        let defaultActions:NSArray = [firstAction, secondAction, thirdAction]
        let minimalActions:NSArray = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions as [AnyObject], forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of all our categories
        let categories:NSSet = NSSet(objects: firstCategory)
            
        let types:UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge
            
        let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
            
        return true
    }
    
    func application(application: UIApplication,
        handleActionWithIdentifier identifier:String?,
        forLocalNotification notification:UILocalNotification,
        completionHandler: (() -> Void)){
            
            if (identifier == "FIRST_ACTION"){
                
                NSNotificationCenter.defaultCenter().postNotificationName("actionOnePressed", object: nil)
                
            }else if (identifier == "SECOND_ACTION"){
                NSNotificationCenter.defaultCenter().postNotificationName("actionTwoPressed", object: nil)
                
            }
            
            completionHandler()
            
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //Go back to articles view
        var root: UIViewController = window!.rootViewController!
        var navController:UINavigationController = root as! UINavigationController
        navController.popToRootViewControllerAnimated(true)

        
        //Create notifications
        let path = fileInDocumentsDirectory("schedule.plist")
        var checkValidation = NSFileManager.defaultManager()
        
        if(checkValidation.fileExistsAtPath(path))
        {
            var mySchedule = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! NSMutableArray
            
            let todaysDay = getToday()
            let currentRawDateCurrent = NSDate()
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .NoStyle
            formatter.timeStyle = .ShortStyle
            let timeString = formatter.stringFromDate(currentRawDateCurrent)
            let currentTime = formatter.dateFromString(timeString)
            
            var bestSchedule: Schedule?
            
            //function to get object with closest time
            for(var i = 0; i < mySchedule.count; i++)
            {
                for(var j = 0; j < (mySchedule[i] as! Schedule).days.count; j++)
                {
                    if((mySchedule[i] as! Schedule).days[j] == todaysDay)
                    {
                        if((mySchedule[i] as! Schedule).time.compare(currentTime!) == NSComparisonResult.OrderedDescending)
                        {
                            if (bestSchedule != nil){
                                if((mySchedule[i] as! Schedule).time.compare(bestSchedule!.time) == NSComparisonResult.OrderedDescending)
                                {
                                    bestSchedule = mySchedule[i] as? Schedule
                                }
                            }
                            else
                            {
                                bestSchedule = mySchedule[i] as? Schedule
                            }
                        }
                    }
                }
            }
            
            if(bestSchedule != nil)
            {
                let cal = NSCalendar.currentCalendar()
                
                var components: NSDateComponents = cal.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: NSDate())
            
                
                let formatter = NSDateFormatter()
                formatter.dateStyle = .NoStyle
                formatter.timeStyle = .ShortStyle
                let timeString = formatter.stringFromDate(bestSchedule!.time)
                
                let fullString = timeString.componentsSeparatedByString(" ")
                let actualTimeString = fullString[0].componentsSeparatedByString(":")
                
                var hours = NSNumberFormatter().numberFromString(actualTimeString[0]) as! Int
                var minutes = NSNumberFormatter().numberFromString(actualTimeString[1]) as! Int
                
                var dateComp:NSDateComponents = NSDateComponents()
                dateComp.year = components.year
                dateComp.month = components.month
                dateComp.day = components.day
                dateComp.hour = hours
                dateComp.minute = minutes
                dateComp.timeZone = NSTimeZone.systemTimeZone()
                
                var date:NSDate = cal.dateFromComponents(dateComp)!
                
                var notification:UILocalNotification = UILocalNotification()
                notification.category = "FIRST_CATEGORY"
                notification.alertBody = "You have news scheduled! Swipe now to take a look!"
                notification.fireDate = date
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
            }
            else
            {
                let calendar = NSCalendar.currentCalendar()
                let tommorrow = calendar.dateByAddingUnit(.CalendarUnitDay, value: 1, toDate: NSDate(), options: nil)
                
                var notification:UILocalNotification = UILocalNotification()
                notification.category = "FIRST_CATEGORY"
                notification.alertBody = "You haven't checked your news in a day! Swipe now to take a look!"
                notification.fireDate = tommorrow
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
            }
            
            
            
        }

        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Refresh UI
        var root: UIViewController = window!.rootViewController!
        var navController:UINavigationController = root as! UINavigationController
        var myContoller:ArticlesViewController = navController.viewControllers[0] as! ArticlesViewController

        myContoller.viewDidLoad()
        
        
        //Remove all notifications
        var app:UIApplication = UIApplication.sharedApplication()
        for oneEvent in app.scheduledLocalNotifications {
            //Cancelling local notifications
            app.cancelLocalNotification(oneEvent as! UILocalNotification)
            
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

