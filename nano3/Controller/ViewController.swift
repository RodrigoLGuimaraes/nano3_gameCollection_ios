//
//  ViewController.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-06.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GameViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let NUMBER_OF_ITEMS_PER_ROW = 3
    
    var gameList = [Game]()
    
    var selectedIndexPath : Int = -1

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
    
    func toggleDeleteBtns(for indexPath: IndexPath, show : Bool) {
            let cell = tableView.cellForRow(at: indexPath) as! ShelfTableViewCell
            
            for case let gameView as GameView in cell.stackView.arrangedSubviews {
                gameView.toggleDeleteBtn(show: show)
        }
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
        
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                toggleDeleteBtns(for: indexPath, show: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! ShelfTableViewCell
        
        cell.stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        //Delete game by longpressing
        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        cell.addGestureRecognizer(longGestureRecognizer)
        
        for i in 0..<NUMBER_OF_ITEMS_PER_ROW {
            let currentIndex = indexPath.row * NUMBER_OF_ITEMS_PER_ROW + i
            let newGame = GameView(id: currentIndex, delegate: self)
            if currentIndex >= gameList.count {
                //Default item
                newGame.frameImageView.isHidden = true
                newGame.gameImageView.isHidden = true
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndexPath {
            return 250
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! ShelfTableViewCell
        if let gameView = cell.stackView.arrangedSubviews.first as? GameView {
            if !gameView.deleteButton.isHidden {
                toggleDeleteBtns(for: indexPath, show: false)
                return
            }
        }
        
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

    func didDeleteGame(id: Int) {
        let game = gameList[id]
        DataModel.shared.deleteGame(game)
        gameList = DataModel.shared.savedGames
        tableView.reloadData()
    }
}

