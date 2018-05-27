//
//  JWTouchableUIView.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 26.05.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class JWTouchableUIView: UIView {
    static let pressedStateDarkeningViewTag = 4309825921
    
    fileprivate let pressedStateDarkeningViewAlpha: CGFloat = 0.3
    
    fileprivate lazy var pressedStateDarkeningView: UIView = { () -> UIView in
        let pressedView = createPinnedSubview()
        pressedView.alpha = 0
        pressedView.backgroundColor = .gray
        pressedView.tag = JWTouchableUIView.pressedStateDarkeningViewTag
        return pressedView
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlight()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        dehighlight()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        dehighlight()
    }
}

extension JWTouchableUIView {
    fileprivate func highlight() {
        bringSubview(toFront: pressedStateDarkeningView)
        self.pressedStateDarkeningView.alpha = self.pressedStateDarkeningViewAlpha
    }
    
    fileprivate func dehighlight() {
        UIView.animate(withDuration: JWCardAnimationConstants.animationDuration / 2) {
            self.pressedStateDarkeningView.alpha = 0
        }
    }
}
