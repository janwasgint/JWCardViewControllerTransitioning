//
//  JWCardUtils.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 19.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

extension UIView {
    func createPinnedSubview() -> UIView {
        let subview = UIView()
        addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.frame = frame
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        return subview
    }
}
