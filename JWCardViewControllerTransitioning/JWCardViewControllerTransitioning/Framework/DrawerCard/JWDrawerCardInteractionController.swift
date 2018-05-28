//
//  JWDrawerCardPanPushAnimator.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 27.05.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class JWDrawerCardInteractionController: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    
    private var shouldCompleteTransition = false
    
    private var drawerViewController: UIViewController?
    private var cardViewController: UIViewController?
    private var drawer: UIView?
    
    init(drawerViewController: UIViewController, cardViewController: UIViewController, drawer: UIView) {
        super.init()
        self.drawerViewController = drawerViewController
        self.cardViewController = cardViewController
        self.drawer = drawer
        let panGetureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(drawerPan(recognizer:)))
        drawer.addGestureRecognizer(panGetureRecognizer)

    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        
    }
    
    @objc func drawerPan(recognizer: UIPanGestureRecognizer) {
        if let drawerViewController = self.drawerViewController {
            let translation = recognizer.translation(in: drawerViewController.view)
            if let view = recognizer.view {
                let statusBarHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
                let topOffsetToDrawerCenterY = statusBarHeight + JWCardAnimationConstants.cardMarginToTop + JWDrawerCardNavigationControllerDelegate.drawerToolBarHeight * 0.5
                
                if (view.center.y + translation.y <= drawerViewController.view.frame.maxY - JWDrawerCardNavigationControllerDelegate.drawerOffset - JWDrawerCardNavigationControllerDelegate.drawerToolBarHeight * 0.5) &&
                    (view.center.y + translation.y >= topOffsetToDrawerCenterY) {
                    view.center = CGPoint(x:view.center.x,
                                          y:view.center.y + translation.y)
                }
                
                let maximumDrawDistance = drawerViewController.view.frame.height - statusBarHeight - JWDrawerCardNavigationControllerDelegate.drawerOffset - JWDrawerCardNavigationControllerDelegate.drawerToolBarHeight - JWCardAnimationConstants.cardMarginToTop
                let drawnDistance = view.center.y - topOffsetToDrawerCenterY
                let percentageOfCompletion = 1 - drawnDistance/maximumDrawDistance
                
                if percentageOfCompletion <= 0.3 {
                    for subview in view.subviews {
                        if (subview.tag != JWTouchableUIView.pressedStateDarkeningViewTag) {
                            subview.alpha = 1 - (percentageOfCompletion / 0.3)
                        } else {
                            subview.layer.cornerRadius = percentageOfCompletion * JWCardAnimationConstants.cornerRadius
                        }
                    }
                }
                view.layer.cornerRadius = percentageOfCompletion * JWCardAnimationConstants.cornerRadius
                
                if (recognizer.state == .cancelled || recognizer.state == .ended || recognizer.state == .failed) {
                    if (percentageOfCompletion < 0.5) {
                        UIView.animate(withDuration: JWCardAnimationConstants.animationDuration) {
                            view.layer.cornerRadius = 0
                            for subview in view.subviews {
                                if (subview.tag != JWTouchableUIView.pressedStateDarkeningViewTag) {
                                    subview.alpha = 1
                                }
                            }
                            view.center = CGPoint(x:view.center.x,
                                                  y:drawerViewController.view.frame.height - JWDrawerCardNavigationControllerDelegate.drawerOffset - JWDrawerCardNavigationControllerDelegate.drawerToolBarHeight * 0.5)
                        }
                    }
                }
            }
            recognizer.setTranslation(CGPoint.zero, in: drawerViewController.view)
            
            
        }
    }
}
