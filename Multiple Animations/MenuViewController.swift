//
//  MenuViewController.swift
//  Multiple Animations
//
//  Created by Francisco Hui on 1/14/15.
//  Copyright (c) 2015 Francisco Hui. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var textPostIcon: UIImageView!
    @IBOutlet weak var textPostLabel: UILabel!
    
    // Create an instance of the transition manager here, where the icons exist on default state
    let transitionManager = MenuTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Not sure why we have this line below for the transitionDelegate
        self.transitioningDelegate = self.transitionManager
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
