//
//  GameView.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-07.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import UIKit

class GameView: UIView {

    var frameImageView: UIImageView = UIImageView()
    var gameImageView: UIImageView = UIImageView()
    
    var centerYConstraint : NSLayoutConstraint = NSLayoutConstraint()
    var originalCenterYConstraintConstant : CGFloat = 0
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(frameImageView)
        self.addSubview(gameImageView)
        frameImageView.translatesAutoresizingMaskIntoConstraints = false
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        centerYConstraint = gameImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        centerYConstraint.isActive = true
        originalCenterYConstraintConstant = centerYConstraint.constant
        
        gameImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        gameImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        gameImageView.widthAnchor.constraint(equalTo: gameImageView.heightAnchor, multiplier: 0.73).isActive = true
        
        frameImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        frameImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        frameImageView.heightAnchor.constraint(equalTo: gameImageView.heightAnchor, multiplier: 1.4).isActive = true
        frameImageView.widthAnchor.constraint(equalTo: frameImageView.heightAnchor, multiplier: 0.73).isActive = true
        
//        frameImageView.image = #imageLiteral(resourceName: "frame")
//        gameImageView.backgroundColor = .red
        
        frameImageView.contentMode = .scaleToFill
        gameImageView.contentMode = .scaleAspectFill
        gameImageView.clipsToBounds = true
    }
    
}
