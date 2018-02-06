//
//  ViewController.swift
//  nano3
//
//  Created by Rodrigo Guimaraes on 2018-02-06.
//  Copyright © 2018 RodrigoLG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ServiceDelegate {
    
    func didReceiveResponse(status: StatusCode, responseJSON: String?) {
        if status == .Success {
            print(responseJSON!)
        } else {
            //TODO: Alert!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Services.shared.getAllGamesFromAYear(delegateTarget: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

