//
//  Cover.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-07.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import Foundation
import ObjectMapper

class Cover : Mappable {
    var width : Int?
    var height : Int?
    var url: String?
    var cloudinary_id : String?
    
    init() {
        url = nil
        height = nil
        width = nil
        cloudinary_id = nil
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        width <- map["width"]
        height <- map["height"]
        url <- map["url"]
        cloudinary_id <- map["cloudinary_id"]
    }
}
