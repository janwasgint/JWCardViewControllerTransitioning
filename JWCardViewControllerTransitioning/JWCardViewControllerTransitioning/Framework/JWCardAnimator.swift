//
//  JWCardAnimator.swift
//  FlightWatch
//
//  Created by Jan Wasgint on 12.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class JWCardAnimator {
    
    fileprivate var _cardPushAnimator: JWCardPushAnimator
    var cardPushAnimator: JWCardPushAnimator? {
        if (currentDepth < 0) {
            return nil
        } else {
            return _cardPushAnimator
        }
    }
    
    fileprivate var _cardPopAnimator: JWCardPopAnimator
    var cardPopAnimator: JWCardPopAnimator? {
        if (currentDepth <= 0) {
            return nil
        } else {
            return _cardPopAnimator
        }
    }
    
    fileprivate var card: [UIView?]
    fileprivate var background: [UIView?]
    fileprivate var container: [UIView?]
    fileprivate var currentDepth: Int
    fileprivate var _navigationBarHidden: Bool
    
    init() {
        _navigationBarHidden = false
        card = [UIView?]()
        background = [UIView?]()
        container = [UIView?]()
        currentDepth = 0
        _cardPushAnimator = JWCardPushAnimator()
        _cardPopAnimator = JWCardPopAnimator()
        _cardPushAnimator.delegate = self
        _cardPopAnimator.delegate = self
    }
    
    func incrementDepth() {
        currentDepth += 1
    }
    
    func decrementDepth() {
        currentDepth -= 1
    }
    
}

extension JWCardAnimator: JWCardAnimatorDelegate {
    func backgroundView(atDepth depth: Int) -> UIView? {
        if (depth >= background.count) {
            return nil
        } else {
            return background[depth]
        }
    }
    
    func setBackgroundView(view: UIView, forDepth depth: Int) {
        if (background.count > depth) {
            background.remove(at: depth)
        }
        background.insert(view, at: depth)
    }
    
    func cardView(atDepth depth: Int) -> UIView? {
        if (depth >= card.count) {
            return nil
        } else {
            return card[depth]
        }
    }
    
    func setCardView(view: UIView, forDepth depth: Int) {
        if (card.count > depth) {
            card.remove(at: depth)
        }
        card.insert(view, at: depth)
    }
    
    func containerView(atDepth depth: Int) -> UIView? {
        if (depth >= container.count) {
            return nil
        } else {
            return container[depth]
        }
    }
    
    func setContainerView(view: UIView, forDepth depth: Int) {
        if (container.count > depth) {
            container.remove(at: depth)
        }
        container.insert(view, at: depth)
    }
    
    func depth() -> Int {
        return currentDepth
    }
    
    func navigationBarHidden() -> Bool {
        return _navigationBarHidden
    }
    
    func setNavigationBarHidden(_ navigationBarHidden: Bool) {
        _navigationBarHidden = navigationBarHidden
    }
    
}
