//
//  parser.swift
//  Group5App
//
//  Created by Andrew Allee on 4/9/15.
//  Copyright (c) 2015 Dan Lasker. All rights reserved.
//

import Foundation
import UIKit

class parser{
    
    var articles = [Article]()
    //var jsonData: NSMutableData = NSMutableData()
    
    func load(fromURLString: String, completionHandler: (parser, String?) -> Void) {
        println("load function called")
        if let url = NSURL(string: fromURLString) {
            let urlRequest = NSMutableURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: {
                (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(self, error.localizedDescription)
                    })
                } else {
                    self.parse(data, completionHandler: completionHandler)
                }
            })
            
            task.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(self, "Invalid URL")
            })
        }
    }
    
    func parse(jsonData: NSData, completionHandler: (parser, String?) -> Void) {
        var jsonError: NSError?
        
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as? NSDictionary {
            if (jsonResult.count > 0)
            {   //parsing algorithm here
                if let status = jsonResult["status"] as? String {
                    if (status == "OK")
                    {
                        println("entered parsing algorithm")
                        //data inside the dictionary is not inherently typed. Must be explicitly casted
                        //using optionals because we don't know what will actually reside in the url we are accessing. maybe nothing
                        
                        //get outer array containing all data
                        if let articleArray = jsonResult["results"] as? NSArray {
                            //loop through the array of articles
                            for articleData in articleArray {
                                //look into each individual story/article object
                                if let title = articleData["title"] as? NSString {
                                    //constructs an object, which calls the constructor, since it was built in to the class
                                    var newTitle = title.htmlString
                                    let section = articleData["section"] as? NSString
                                    let articleURL = articleData["url"] as? NSString
                                    let newEntry = Article(forTitle: newTitle as String, forSection: section! as String, forURL: articleURL! as String)
                                    //now access the array of media objects
                                    if let mediaData = articleData["media"] as? NSArray {
                                        //loop through the companies
                                        if let index = mediaData[0] as? NSDictionary {
                                            if let type = index["type"] as? NSString{
                                                if(type == "image"){
                                                    //do stuff here to access metadata that will be stored in image object
                                                    if let metadata = index["media-metadata"] as? NSArray{
                                                        if let imageInfo = metadata[0] as? NSDictionary{
                                                            if let imageURL = imageInfo["url"] as? NSString{
                                                                let imageHeight = imageInfo["height"] as? Int
                                                                let imageWidth = imageInfo["width"] as? Int
                                                                let newImage = ImageData(forURL:imageURL as String, forHeight:imageHeight!, forWidth:imageWidth!);
                                                                newEntry.image = newImage
                                                                articles.append(newEntry)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                        dispatch_async(dispatch_get_main_queue(), {
                            completionHandler(self, nil)
                        })
                    }
                
            }else {
            if let unwrappedError = jsonError {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(self, "\(unwrappedError)")
                })
            }
        }
    }
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    func connectNow(){
        println("connection attempted")
        
        //NSURL() returns an optional NSURL object based on the customized web URL below
        //This URL access the Most Popular API from the NYT. It returns the 20 most shared articles from their site
        let url = NSURL(string: "http://api.nytimes.com/svc/mostpopular/v2/mostviewed/Arts/1.json?api-key=b32dcf0a887c83fe37220653ad10c91b:8:71573066")

        if(url != nil){
            let request = NSURLRequest(URL: url!)
            let connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
            //NSURLConnection returns an optional connection object
            //delegate:self => means that the code that responds to the connection once it is started is in the object in which it resides (the view controller in this case)
            
            if (connection != nil) {
                //actually starts connection (required because startImmediately: is false)
                connection!.start()
            }
        }
    }

    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        println("connection received response")
        // Response received to request. Initialize jsonData with a new data object
        jsonData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        var i = 0
        println("append \(i)")
        // Append the received data to jsonData (b/c networks typically load data piecewise, not all at once)
        jsonData.appendData(data)
    }
    
    //PARSE THE JSON
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // The data is finished loading and jsonData holds the result
        
        // Convert the JSON data that was loaded into an NSDictionary using JSON deserialization
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        
        println("connection finished loading")
        
        //now that we have a Foundation Object that Swift can read, we parse it
        if (jsonResult.count > 0)
        {
            // https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TypeCasting.html
            //JSON result is a dictionary, and dictionary elements are accessed by key-value pairs. In this case, "status" is paired with "ok" in the JSON
            if let status = jsonResult["status"] as? String {
                if (status == "OK")
                {   println("entered parsing algorithm")
                    //data inside the dictionary is not inherently typed. Must be explicitly casted
                    //using optionals because we don't know what will actually reside in the url we are accessing. maybe nothing
                    
                    //get outer array containing all data
                    if let articleArray = jsonResult["results"] as? NSArray {
                        //loop through the array of articles
                        for articleData in articleArray {
                            //look into each individual story/article object
                            if let title = articleData["title"] as? NSString {
                                //constructs an object, which calls the constructor, since it was built in to the class
                                let section = articleData["section"] as? NSString
                                let articleURL = articleData["url"] as? NSString
                                let newEntry = Article(forTitle: title as String, forSection: section! as String, forURL: articleURL! as String)
                                
                                
                                //now access the array of media objects
                                if let mediaData = articleData["media"] as? NSArray {
                                    //loop through the companies
                                    if let index = mediaData[0] as? NSDictionary {
                                        if let type = index["type"] as? NSString{
                                            if(type == "image"){
                                                //do stuff here to access metadata that will be stored in image object
                                                if let metadata = index["media-metadata"] as? NSArray{
                                                    if let imageInfo = metadata[0] as? NSDictionary{
                                                        if let imageURL = imageInfo["url"] as? NSString{
                                                            let imageHeight = imageInfo["height"] as? Int
                                                            let imageWidth = imageInfo["width"] as? Int
                                                            let newImage = ImageData(forURL:imageURL as String, forHeight:imageHeight!, forWidth:imageWidth!);
                                                            newEntry.image = newImage
                                                            articles.append(newEntry)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }

    
    

*/
}
}