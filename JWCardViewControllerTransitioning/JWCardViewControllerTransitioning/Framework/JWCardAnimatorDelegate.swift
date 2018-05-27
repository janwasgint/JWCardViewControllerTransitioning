//
//  JWCardAnimatorDelegate.swift
//  FlightWatch
//
//  Created by Jan Wasgint on 12.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

protocol JWCardAnimatorDelegate {
    func backgroundView(atDepth: Int) -> UIView?
    func setBackgroundView(view: UIView, forDepth: Int)
    
    func cardView(atDepth: Int) -> UIView?
    func setCardView(view: UIView, forDepth: Int)
    
    func containerView(atDepth: Int) -> UIView?
    func setContainerView(view: UIView, forDepth: Int)
    
    func depth() -> Int
    
    func navigationBarHidden() -> Bool
    func setNavigationBarHidden(_ navigationBarHidden: Bool)
    
    func tabBarHidden() -> Bool
    func setTabBarHidden(_ tabBarHidden: Bool)
    
    func offsetToBottom() -> CGFloat
}
