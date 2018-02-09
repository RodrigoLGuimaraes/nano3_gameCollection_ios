//
//  DataModel.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-09.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import Foundation
import ObjectMapper

class DataModel {
    public static let shared = DataModel()
    
    var savedGames = [Game]()
    let SAVED_GAMES_KEY = "savedGamesKey"
    
    init() {
        let defaults = UserDefaults.standard
        
        if let savedGamesJSon = defaults.string(forKey: SAVED_GAMES_KEY) {
            savedGames = Mapper<Game>().mapArray(JSONString: savedGamesJSon)!
        }
    }
    
    func updateSavedGames(game : Game) {
        for testGame in savedGames {
            if testGame.id == game.id {
                //Game already exists in database
                return
            }
        }
        
        savedGames.append(game)
        let defaults = UserDefaults.standard
        defaults.set(savedGames.toJSONString()!, forKey: SAVED_GAMES_KEY)
    }
}
