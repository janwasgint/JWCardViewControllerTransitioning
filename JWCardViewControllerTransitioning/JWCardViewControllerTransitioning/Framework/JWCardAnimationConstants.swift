//
//  JWCardAnimationConstants.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 10/09/16.
//  Copyright © 2016 Jan Wasgint. All rights reserved.
//

import UIKit

class JWCardAnimationConstants {
    static let cardMarginToTop = UIApplication.shared.statusBarFrame.height + 2 * foregroundBorderWidth
    
    static let foregroundBorderWidth: CGFloat = 5
    static let backgroundBorderWidth: CGFloat = 2 * foregroundBorderWidth
    
    static let cornerRadius: CGFloat = 10 * (UIApplication.shared.windows.first?.frame.height ?? 667) / 667
    
    static let animationDuration: Double = 0.4
    
    static let foregroundAlpha: CGFloat = 1.0
    static let backgroundAlpha: CGFloat = 0.7
}
