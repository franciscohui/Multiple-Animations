//
//  TransitionManager.swift
//  Multiple Animations
//
//  Created by Francisco Hui on 1/20/15.
//  Copyright (c) 2015 Francisco Hui. All rights reserved.
//

import UIKit

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting = false
    
    //MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // I still don't fully understand how to use a transition manager
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //why use UIViewControllerContextTransitioning vs something else? when does auto complete not appear?

        let container = transitionContext.containerView()
        
        // creating a tuple for the screens: to switch between them? or swap them in/out as needed?
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!,transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
//        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewKey)!
//        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewKey)!
        
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController = !self.presenting ? screens.from as MenuViewController : screens.to as MenuViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        // prepare the menu
        if (self.presenting){
            menuView.alpha = 0
        }
        
        // add both views to the view controller
        container.addSubview(bottomView)
        container.addSubview(menuView)
        
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
                // either fade in or fade out
                menuView.alpha = self.presenting ? 1 : 0

            }, completion: { finished in
                
                // tell our transitionContext object that we've finished the animation
                transitionContext.completeTransition(true)
                
                // because of a bug, we have to manually add our 'to view' back 
        //        UIApplication.sharedApplication().keyWindow.addSubview(screens.to.view)
        })
    }
    
    // return how many seconds the transition animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval{ // what does -> mean?
        return 2.0
    }
        
    //MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animator when presenting a viewcontroller
    // remember that an animator (or animation controller) is any object that adheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}
