//
//  DiscoverViewController.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-08.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import UIKit
import ObjectMapper

class DiscoverViewController: UIViewController, UICollectionViewDataSource, ServiceDelegate, PinterestLayoutDelegate, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var gameList = [Game]()
    
    var searchTextUsed = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
            
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        } else {
            //TODO: Alert!
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchTextUsed = searchBar.text!
        Services.shared.searchGames(text: searchTextUsed, delegateTarget: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Services.shared.searchGames(text: searchTextUsed, delegateTarget: self)
        
        collectionView.backgroundColor  = UIColor.clear
        collectionView.dataSource = self
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        searchBar.delegate = self
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
