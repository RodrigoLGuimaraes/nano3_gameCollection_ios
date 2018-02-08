//
//  GameCollectionViewCell.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-08.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateCell(imageLink : String?, name : String) {
        self.image.image = #imageLiteral(resourceName: "loading")
        if let link = imageLink {
            self.image.downloadedFrom(link: link)
        } else {
            self.image.image = #imageLiteral(resourceName: "noImage")
        }
        self.nameLabel.text = name
    }
}
