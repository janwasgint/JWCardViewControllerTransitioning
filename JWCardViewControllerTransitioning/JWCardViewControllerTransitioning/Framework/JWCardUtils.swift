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
        subview.frame = frame
        subview.topAnchor.constraint(equalTo: topAnchor)
        subview.leftAnchor.constraint(equalTo: leftAnchor)
        subview.rightAnchor.constraint(equalTo: rightAnchor)
        subview.bottomAnchor.constraint(equalTo: bottomAnchor)
        return subview
    }
}
