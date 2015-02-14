//
//  TransitionManager.swift
//  Multiple Animations
//
//  Created by Francisco Hui on 1/20/15.
//  Copyright (c) 2015 Francisco Hui. All rights reserved.
//

import UIKit

// added UIViewControllerInteractiveTransitioning so the transition manager can accept interactions
// the three UIViewControllers and the UIPercentDrivenInteractiveTransition are keys to make the MenuTransitionManager userful
class MenuTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning {
    
    private var presenting = false
    private var interactive = false
    
    // private variables can only be referenced within this object
    private var enterPanGesture: UIScreenEdgePanGestureRecognizer!
    
    // not private so that it can be also used by other objects: ie. the MainViewController
    var sourceViewController: UIViewController! {
        //executed each time sourceViewController is updated
        didSet {
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action: "handleOnstagePan:")
            self.enterPanGesture.edges = UIRectEdge.Left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
        }
    }
    
    func handleOnstagePan(pan: UIPanGestureRecognizer){
        
        // how much distance have we panned in reference to the parent view?
        let translation = pan.translationInView(pan.view!)
        
        // convert pan horizontal distance to a percentage
        let d = translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
        
        // act on different states sent by the gesture recognizer
        switch (pan.state){
            
            case UIGestureRecognizerState.Began:
                
                // turn on interactive flag
                self.interactive = true
            
                // trigger the start of the transition
                self.sourceViewController.performSegueWithIdentifier("presentMenu", sender: self)
                break

            case UIGestureRecognizerState.Changed:
            
                // update progress of the transition
                self.updateInteractiveTransition(d)
                break
            
            // when the interaction .Ended, .Cancelled, .Failed
            default:
                
                // turn off interactive flag and finish the transition. Does finishing the animation set it to initial or end state?
                self.interactive = false
                self.finishInteractiveTransition()
        }
        
    }
    
    //MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // I still don't fully understand how to use a transition manager
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

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
            self.offStageMenuController(menuViewController)
        }

        // add both views to the view controller
        container.addSubview(bottomView)
        container.addSubview(menuView)
        
        let duration = self.transitionDuration(transitionContext)
        
        
        // perform the animation
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            if (self.presenting){
                //objects slide in
                self.onStageMenuController(menuViewController)
            }
            else{
                // offstage items: slide out
                self.offStageMenuController(menuViewController)
            }
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished the animation
                transitionContext.completeTransition(true)
                
                // because of a bug, we have to manually add our 'to view' back and unwrap keyWindow with an exclamation mark (?)
                UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
            })
        }

        // a new function to stagger the icons
    
        // a function called offStage that takes in an amount parameter called (or of type?) CGFloat
        // this -> is called an arrow operator, it has something to do with objects and dot operators
        func offStage(amount: CGFloat) -> CGAffineTransform {
            return CGAffineTransformMakeTranslation(amount, 0)
        }

    
        // a new function to create an animation for all 12 IBOutlets
        func offStageMenuController(menuViewController: MenuViewController){

            menuViewController.view.alpha = 0
        
            // set up 2D transitions for animations
            let topRowOffset: CGFloat = 300
            let middleRowOffset: CGFloat = 150
            let bottomRowOffset: CGFloat = 50
            
            // let offstageLeft = CGAffineTransformMakeTranslation(-150,0)
            // let offstageRight = CGAffineTransformMakeTranslation(150,0)


            
            // prepare the menu to slide in
            menuViewController.textPostIcon.transform = self.offStage(-topRowOffset)
            menuViewController.textPostLabel.transform = self.offStage(-topRowOffset)
            
            menuViewController.photoPostIcon.transform = self.offStage(topRowOffset)
            menuViewController.photoPostLabel.transform = self.offStage(topRowOffset)
            
            menuViewController.quotePostIcon.transform = self.offStage(-middleRowOffset)
            menuViewController.quotePostLabel.transform = self.offStage(-middleRowOffset)
            
            menuViewController.linkPostIcon.transform = self.offStage(middleRowOffset)
            menuViewController.linkPostLabel.transform = self.offStage(middleRowOffset)
            
            menuViewController.chatPostIcon.transform = self.offStage(-bottomRowOffset)
            menuViewController.chatPostLabel.transform = self.offStage(-bottomRowOffset)
            
            menuViewController.audioPostIcon.transform = self.offStage(bottomRowOffset)
            menuViewController.audioPostLabel.transform = self.offStage(bottomRowOffset)

        }
    
        func onStageMenuController(menuViewController: MenuViewController){
            menuViewController.view.alpha = 1
            
            menuViewController.textPostIcon.transform = CGAffineTransformIdentity
            menuViewController.textPostLabel.transform = CGAffineTransformIdentity
            
            menuViewController.photoPostIcon.transform = CGAffineTransformIdentity
            menuViewController.photoPostLabel.transform = CGAffineTransformIdentity

            menuViewController.quotePostIcon.transform = CGAffineTransformIdentity
            menuViewController.quotePostLabel.transform = CGAffineTransformIdentity
            
            menuViewController.linkPostIcon.transform = CGAffineTransformIdentity
            menuViewController.linkPostLabel.transform = CGAffineTransformIdentity

            menuViewController.chatPostIcon.transform = CGAffineTransformIdentity
            menuViewController.chatPostLabel.transform = CGAffineTransformIdentity
            
            menuViewController.audioPostIcon.transform = CGAffineTransformIdentity
            menuViewController.audioPostLabel.transform = CGAffineTransformIdentity
            
        }
    
    // return how many seconds the transition animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval{ // what does -> mean?
        return 0.5
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
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self: nil
        
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self: nil
    }
}
