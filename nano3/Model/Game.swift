//
//  GamesListResponse.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-06.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import Foundation
import ObjectMapper

class Game : Mappable {
    var id : Int!
    var name : String?
    var url : String?
    var storyline : String?
    var popularity : Double?
    var rating : Double?
    var total_rating : Double?
    var cover : Cover?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        url <- map["url"]
        storyline <- map["storyline"]
        popularity <- map["popularity"]
        rating <- map["rating"]
        total_rating <- map["total_rating"]
        cover <- map["cover"]
    }
}
