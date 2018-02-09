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
    var deleteButton : UIButton = UIButton()
    
    var id : Int = 0
    var delegate : GameViewDelegate?
    
    var centerYConstraint : NSLayoutConstraint = NSLayoutConstraint()
    var originalCenterYConstraintConstant : CGFloat = 0
    
    init(id: Int, delegate: GameViewDelegate) {
        super.init(frame: CGRect.zero)
        self.id = id
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setupViews()
    }
    
    func setupViews() {
        self.addSubview(frameImageView)
        self.addSubview(gameImageView)
        self.addSubview(deleteButton)
        frameImageView.translatesAutoresizingMaskIntoConstraints = false
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        //Delete button
        deleteButton.setImage(#imageLiteral(resourceName: "trash"), for: .normal)
        deleteButton.setTitle("", for: .normal)
        deleteButton.centerXAnchor.constraint(equalTo: frameImageView.centerXAnchor).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: frameImageView.centerYAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: frameImageView.widthAnchor, multiplier: 0.8).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor, multiplier: 1).isActive = true
        deleteButton.isHidden = true
        
        deleteButton.addTarget(self, action: #selector(didClickButton(sender:)), for: .touchUpInside)
    }
    
    @objc func didClickButton(sender: UIButton) {
        delegate?.didDeleteGame(id: id)
    }
    
    func toggleDeleteBtn(show : Bool) {
        if gameImageView.isHidden && frameImageView.isHidden {
            return
        }
        deleteButton.isHidden = false
    }
    
}

protocol GameViewDelegate {
    func didDeleteGame(id : Int)
}
