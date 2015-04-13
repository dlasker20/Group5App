//
//  Article.swift
//  RendeNews
//
//  Created by Andrew Allee on 3/16/15.
//  Copyright (c) 2015 Andrew Allee. All rights reserved.
//
import UIKit


class Article: NSObject {
    
    var title: String? = "title"
    var section:String? = "section"
    var url:String? = "www.google.com"
    var image:ImageData?
    
    init(forTitle:String, forSection:String, forURL:String) {
        self.title = forTitle
        self.section = forSection
        self.url = forURL
    }

}