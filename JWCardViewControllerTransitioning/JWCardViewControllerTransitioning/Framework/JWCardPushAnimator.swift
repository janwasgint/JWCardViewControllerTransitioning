//
//  CardTransitionAnimator.swift
//  FlightWatch
//
//  Created by Jan Wasgint on 12.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class JWCardPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var delegate: JWCardAnimatorDelegate?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return JWCardAnimationConstants.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let delegate = self.delegate,
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let navigationController = fromViewController.navigationController
            else {
                return
        }
        let containerView = transitionContext.containerView.createPinnedSubview()
        delegate.setContainerView(view: containerView, forDepth: delegate.depth())
        
        if (delegate.depth() == 0) {
            delegate.setNavigationBarHidden(navigationController.isNavigationBarHidden)
            delegate.setTabBarHidden(navigationController.tabBarController?.tabBar.isHidden ?? true)
        }
        
        let cardMovingToBackground: UIView
        
        if (delegate.depth() == 0) {
            cardMovingToBackground = navigationController.view.window ?? navigationController.view
        } else {
            cardMovingToBackground = delegate.cardView(atDepth: delegate.depth() - 1) ?? UIView()
            
            if let disappearingBackgroundCard = delegate.backgroundView(atDepth: delegate.depth() - 1) {
                disappearingBackgroundCard.removeFromSuperview()
                containerView.addSubview(disappearingBackgroundCard)
                
                UIView.animate(withDuration: JWCardAnimationConstants.animationDuration / 4, animations: {
                    disappearingBackgroundCard.alpha = 0
                }) { _ in
                    disappearingBackgroundCard.removeFromSuperview()
                    delegate.containerView(atDepth: delegate.depth() - 1)?.addSubview(disappearingBackgroundCard)
                }
            }
        }
        
        let cardMovingToBackgroundSnapshot = cardMovingToBackground.snapshotView(afterScreenUpdates: false) ?? UIView()
        cardMovingToBackgroundSnapshot.frame = cardMovingToBackground.frame
        cardMovingToBackgroundSnapshot.clipsToBounds = true
        delegate.setBackgroundView(view: cardMovingToBackgroundSnapshot, forDepth: delegate.depth())
        
        fromViewController.view.removeFromSuperview()
        containerView.addSubview(cardMovingToBackgroundSnapshot)
        containerView.addSubview(toViewController.view)
        
        delegate.setCardView(view: toViewController.view, forDepth: delegate.depth())
        toViewController.view.frame = toViewController.view.frame.offsetBy(dx: 0, dy: toViewController.view.frame.height)
        
        navigationController.isNavigationBarHidden = true
        navigationController.tabBarController?.tabBar.isHidden = true
        
        JWCardAnimation.moveViewToBackground(view: cardMovingToBackgroundSnapshot)
        
        JWCardAnimation.showAsCard(view: toViewController.view) { _ in
            toViewController.view = containerView
            delegate.setContainerView(view: containerView, forDepth: delegate.depth())
            transitionContext.completeTransition(true)
        }
    }
}


