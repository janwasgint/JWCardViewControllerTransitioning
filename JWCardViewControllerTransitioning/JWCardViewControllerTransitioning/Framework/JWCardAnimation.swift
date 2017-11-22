//
//  JWCardAnimation.swift
//  FlightWatch
//
//  Created by Jan Wasgint on 11.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class JWCardAnimation { //MARK: Show/Hide Card View
    
    static func showAsCard(view: UIView, completion: ((Bool) -> ())? = nil) {
        let borderWidth = JWCardAnimationConstants.foregroundBorderWidth
        let endFrameY = JWCardAnimationConstants.cardMarginToTop
        animateViewInDirectionY(view: view,
                                borderWidth: borderWidth,
                                endFrameY: endFrameY,
                                completion: completion)
    }
    
    static func hideCard(view: UIView, bottomOfView: CGFloat, completion: ((Bool) -> ())? = nil) {
        let borderWidth = JWCardAnimationConstants.foregroundBorderWidth
        animateViewInDirectionY(view: view,
                                borderWidth: borderWidth,
                                endFrameY: bottomOfView,
                                completion: completion)
    }
}

extension JWCardAnimation { //MARK: Hide/Show Background View
    static func moveViewToBackground(view: UIView,
                                     borderWidth: CGFloat = JWCardAnimationConstants.backgroundBorderWidth,
                                     completion: ((Bool) -> ())? = nil) {
        let newFrame = calculateCardViewFrame(view: view, borderWidth: borderWidth, operation: +)
        let newAlpha = JWCardAnimationConstants.backgroundAlpha
        let newCornerRadius = JWCardAnimationConstants.cornerRadius
        animateViewInDirectionZ(view: view, newFrame: newFrame, newAlpha: newAlpha, newCornerRadius: newCornerRadius, completion: completion)
    }
    
    static func moveViewBackToForeground(view: UIView,
                                         borderWidth: CGFloat = JWCardAnimationConstants.backgroundBorderWidth,
                                         completion: ((Bool) -> ())? = nil) {
        let newFrame = calculateCardViewFrame(view: view, borderWidth: borderWidth, operation: -)
        let newAlpha = JWCardAnimationConstants.foregroundAlpha
        let newCornerRadius: CGFloat = 0
        animateViewInDirectionZ(view: view, newFrame: newFrame, newAlpha: newAlpha, newCornerRadius: newCornerRadius, completion: completion)
    }
    
    static func moveViewBackToForegroundAsCard(view: UIView,
                                               frame: CGRect,
                                               borderWidth: CGFloat = JWCardAnimationConstants.backgroundBorderWidth,
                                               completion: ((Bool) -> ())? = nil) {
        animateViewInDirectionZ(view: view, newFrame: frame, newAlpha: JWCardAnimationConstants.foregroundAlpha, newCornerRadius: borderWidth, completion: completion)
    }    
}


extension JWCardAnimation { //MARK: Animation Helper
    fileprivate static func animateViewInDirectionY(view: UIView,
                                                    borderWidth: CGFloat,
                                                    endFrameY: CGFloat,
                                                    completion: ((Bool) -> ())? = nil) {
        let x = view.frame.minX
        let width = view.frame.width
        let height = endFrameY > JWCardAnimationConstants.cardMarginToTop ? view.frame.height : view.frame.height - JWCardAnimationConstants.cardMarginToTop
        
        let firstKeyFrame = CGRect(x: x, y: view.frame.minY, width: width, height: height)
        let secondKeyFrame = CGRect(x: x, y: endFrameY, width: width, height: height)
        
        view.layer.cornerRadius = JWCardAnimationConstants.cornerRadius
        view.frame = firstKeyFrame
        
        UIView.animate(withDuration: JWCardAnimationConstants.animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            view.frame = secondKeyFrame
        }, completion: completion)
    }
    
    fileprivate static func calculateCardViewFrame(view: UIView,
                                                   borderWidth: CGFloat,
                                                   operation: (CGFloat, CGFloat) ->  CGFloat) -> CGRect {
        let borderedX = operation(view.frame.minX, borderWidth)
        let borderedY = operation(UIApplication.shared.statusBarFrame.height / 2, UIApplication.shared.statusBarFrame.height / 2)
        let borderedWidth = operation(view.frame.width, -2 * borderWidth)
        let borderedHeight = operation(view.frame.height, -2 * borderWidth)
        
        return CGRect(x: borderedX, y: borderedY, width: borderedWidth, height: borderedHeight)
    }
    
    fileprivate static func animateViewInDirectionZ(view: UIView,
                                                    newFrame: CGRect,
                                                    newAlpha: CGFloat,
                                                    newCornerRadius: CGFloat = JWCardAnimationConstants.cornerRadius,
                                                    completion: ((Bool) -> ())? = nil) {
        UIView.animate(withDuration: JWCardAnimationConstants.animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            view.frame = newFrame
            view.alpha = newAlpha
            view.layer.cornerRadius = newCornerRadius
        }, completion: completion)
    }
}
