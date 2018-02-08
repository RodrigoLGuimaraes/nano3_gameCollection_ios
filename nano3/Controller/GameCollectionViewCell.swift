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
    
    func updateCell(image : UIImage, name : String) {
        self.image.image = image
        self.nameLabel.text = name
    }
}
