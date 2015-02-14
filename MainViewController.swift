//
//  MainViewController.swift
//  Multiple Animations
//
//  Created by Francisco Hui on 1/16/15.
//  Copyright (c) 2015 Francisco Hui. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    // Transition manager isn't needed on this view because the icons don't live on this view
    //let MenuTransitionManager = TransitionManager()
    
    let transitionManager = MenuTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // connecting the transition manager to this MainViewController
        // set variable transitoinManager to equal MenuTransitionManager object.
        // in there, find sourceViewController variable then set it to self (MainViewController)
        self.transitionManager.sourceViewController = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let menu = segue.destinationViewController as MenuViewController
        menu.transitioningDelegate = self.transitionManager
    }
    
    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
