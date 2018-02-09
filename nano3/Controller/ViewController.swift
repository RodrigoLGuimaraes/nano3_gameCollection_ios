//
//  ViewController.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-06.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let NUMBER_OF_ITEMS_PER_ROW = 3
    
    var gameList = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gameList = DataModel.shared.savedGames
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 4
        if gameList.count % 3 != 0 {
            result = 1 + gameList.count / 3
        } else {
            result = gameList.count / 3
        }
        
        return result < 4 ? 4 : result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! ShelfTableViewCell
        
        cell.stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        for i in 0..<NUMBER_OF_ITEMS_PER_ROW {
            let newGame = GameView()
            let currentIndex = indexPath.row * NUMBER_OF_ITEMS_PER_ROW + i
            if currentIndex >= gameList.count {
                //Default item
                newGame.frameImageView.image = UIImage()
                newGame.frameImageView.backgroundColor = UIColor.white.withAlphaComponent(0)
                newGame.gameImageView.image = UIImage()
                newGame.gameImageView.backgroundColor = UIColor.white.withAlphaComponent(0)
            } else {
                
                if let rating = gameList[currentIndex].total_rating {
                    if rating > 80.0 {
                        newGame.frameImageView.image = #imageLiteral(resourceName: "frame")
                    } else {
                        newGame.frameImageView.image = #imageLiteral(resourceName: "frame2")
                    }
                } else {
                    newGame.frameImageView.image = #imageLiteral(resourceName: "frame2")
                }
                
                let cover = gameList[currentIndex].cover ?? Cover()
                if let url = cover.url {
                    newGame.gameImageView.image = #imageLiteral(resourceName: "loading")
                    newGame.gameImageView.downloadedFrom(link: url)
                } else {
                    newGame.gameImageView.image = #imageLiteral(resourceName: "noImage")
                }
            }
            cell.stackView.addArrangedSubview(newGame)
        }
        
        var currentTimeSum : Double = 0.1
        for gameView in cell.stackView.arrangedSubviews {
            let time = 0.1 + currentTimeSum
            gameView.alpha = 0
            let frame = CGRect(x: gameView.frame.minX, y: gameView.frame.minY - 25, width: gameView.frame.width, height: gameView.frame.height)
            gameView.frame = frame
            UIView.animate(withDuration: time) {
                let frame = CGRect(x: gameView.frame.minX, y: gameView.frame.minY + 25, width: gameView.frame.width, height: gameView.frame.height)
                gameView.frame = frame
                gameView.alpha = 1
            }
            currentTimeSum += 0.2
        }
        
        return cell
    }
    
    var selectedIndexPath : Int = -1
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndexPath {
            return 250
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndexPath == indexPath.row {
            selectedIndexPath = -1
        } else {
            selectedIndexPath = indexPath.row
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

