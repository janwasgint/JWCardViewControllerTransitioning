//
//  CardTransitionAnimator.swift
//  FlightWatch
//
//  Created by Jan Wasgint on 12.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class JWCardPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var delegate: JWCardAnimatorDelegate?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return JWCardAnimationConstants.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let delegate = self.delegate,
            let cardView = delegate.cardView(atDepth: delegate.depth() - 1),
            let backgroundView = delegate.backgroundView(atDepth: delegate.depth() - 1),
            let containerView = delegate.containerView( atDepth: delegate.depth() - 1),
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let navigationController = toViewController.navigationController
            else {
                return
        }
        
        let cardFrame = cardView.frame
        
        JWCardAnimation.hideCard(view: cardView, bottomOfView: containerView.frame.maxY) { _ in
            fromViewController.view = cardView
            fromViewController.view.removeFromSuperview()
        }
        
        let transitionCompletion = {
            backgroundView.removeFromSuperview()
            transitionContext.containerView.addSubview(toViewController.view)
            containerView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
        
        if delegate.depth() == 1 {
            JWCardAnimation.moveViewBackToForeground(view: backgroundView) { _ in
                
                navigationController.isNavigationBarHidden = delegate.navigationBarHidden()
                transitionCompletion()
            }
        } else {
            let appearingBackgroundCard = delegate.backgroundView(atDepth: delegate.depth() - 2) ?? UIView()
            appearingBackgroundCard.removeFromSuperview()
            containerView.insertSubview(appearingBackgroundCard, at: 0)

            UIView.animate(withDuration: JWCardAnimationConstants.animationDuration / 4, delay: (3 * JWCardAnimationConstants.animationDuration) / 4, options: .curveLinear, animations: {
                appearingBackgroundCard.alpha = JWCardAnimationConstants.backgroundAlpha
            })
            
            JWCardAnimation.moveViewBackToForegroundAsCard(view: backgroundView, frame: cardFrame) { _ in
                appearingBackgroundCard.removeFromSuperview()
                delegate.containerView(atDepth: delegate.depth() - 2)?.insertSubview(appearingBackgroundCard, at: 0)
                transitionCompletion()
            }
        }
    }
    
}

