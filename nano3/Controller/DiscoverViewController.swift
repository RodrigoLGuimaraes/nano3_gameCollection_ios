//
//  DiscoverViewController.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-08.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import UIKit
import ObjectMapper

class DiscoverViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, ServiceDelegate, PinterestLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var gameList = [Game]()
    
    func didReceiveResponse(status: StatusCode, responseJSON: String?) {
        if status == .Success {
            gameList = Mapper<Game>().mapArray(JSONString: responseJSON!)!
            
            gameList = gameList.filter({ (game) -> Bool in
                if let cover = game.cover {
                    if let url = cover.url {
                        return true
                    }
                }
                return false
            })
            
            collectionView.reloadData()
        } else {
            //TODO: Alert!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Services.shared.getAllGamesFromAYear(delegateTarget: self)
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        pickerView.selectRow(GAME_YEARS.count-1, inComponent: 0, animated: false)
        
        collectionView.backgroundColor  = UIColor.clear
        collectionView.dataSource = self
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GAME_YEARS.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(GAME_YEARS[row])"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! GameCollectionViewCell
        
        let game = gameList[indexPath.row]
        
        cell.updateCell(imageLink: game.cover?.url, name: game.name ?? "Unknown")
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        if let rating = gameList[indexPath.row].total_rating {
            print("rating = \(rating)")
            return 150 + (3 * CGFloat(rating - 50))
        }
        return 150
    }
}
