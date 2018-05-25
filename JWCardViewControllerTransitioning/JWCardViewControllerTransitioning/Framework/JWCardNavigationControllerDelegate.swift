
//
//  JWCardNavigationControllerDelegate.swift
//  FlightWatch
//
//  Created by Jan Wasgint on 12.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class JWCardNavigationControllerDelegate: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    let cardAnimator = JWCardAnimator()
    internal var depthOfLastDidShow: Int?
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (operation == .push) {
            return cardAnimator.cardPushAnimator
        } else {
            return cardAnimator.cardPopAnimator
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Workaround to enable interactive pop gesture recognizer in the non-card part of the navigationcontroller
        // (animationControllerForOperation is not called when using the interactive pop gesture recognizer)
        guard let depthOfCurrentDidShow = navigationController.depthOfViewControllerInNavigationStack(viewController: viewController) else {
            return
        }
        
        if let depthOfLastDidShow = self.depthOfLastDidShow {
            if (depthOfCurrentDidShow == depthOfLastDidShow + 1) {
                self.cardAnimator.incrementDepth()
            } else if (depthOfCurrentDidShow == depthOfLastDidShow - 1) {
                self.cardAnimator.decrementDepth()
            }
        }
        self.depthOfLastDidShow = depthOfCurrentDidShow
    }
    
    //Mark: Static setup
    static var navigationControllerDelegates = [JWCardNavigationControllerDelegate]()
    
    class func startPresentingViewControllersAsCards(inNavigationController navigationController: UINavigationController) {
        if (navigationController.delegate as? JWCardNavigationControllerDelegate == nil) {
            let navigationControllerDelegate = JWCardNavigationControllerDelegate()
            navigationController.delegate = navigationControllerDelegate
            
            navigationController.interactivePopGestureRecognizer?.delegate = navigationControllerDelegate
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationControllerDelegates.append(navigationControllerDelegate)
        }
    }
}

extension UINavigationController {
    func depthOfViewControllerInNavigationStack(viewController searchedViewController: UIViewController) -> Int? {
        var i = 0;
        for viewController in viewControllers {
            if (viewController === searchedViewController) {
                return i
            }
            i += 1
        }
        return nil
    }
}

