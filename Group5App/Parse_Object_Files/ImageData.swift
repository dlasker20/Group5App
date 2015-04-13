//
//  ImageData.swift
//  RendeNews
//
//  Created by Andrew Allee on 3/16/15.
//  Copyright (c) 2015 Andrew Allee. All rights reserved.
//

import Foundation

class ImageData: NSObject {
    
    var url: String? = "www.google.com/images"
    var height: Int? = 5
    var width: Int? = 5
    
    init(forURL:String, forHeight:Int, forWidth:Int) {
        self.url = forURL
        self.height = forHeight
        self.width = forWidth
    }
    
}
