//
//  Utils.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 18.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit
import AVFoundation

extension UITableView {
    func style() {
        let headerViewHeight = 1 / UIScreen.main.scale
        let headerViewWidth = bounds.width
        let headerViewFrame = CGRect(x: 0, y: 0, width: headerViewWidth, height: headerViewHeight)
        let headerView = UIView(frame: headerViewFrame)
        headerView.backgroundColor = separatorColor
        
        tableHeaderView = headerView
        tableFooterView = UIView()
    }
}

extension UITableViewCell {
    func style() -> UITableViewCell {
        textLabel?.numberOfLines = 0
        textLabel?.font = UIFont.systemFont(ofSize: 20)
        return self
    }
}

extension String {
    static let cardIdentifier = "CardViewControllerIdentifier"
    static let navigationControllerIdentifier = "NavigationViewControllerIdentifier"
    static let multipleCardsIdentifier = "MultipleCardsViewControllerIdentifier"
}

extension UIColor {
    static let systemButtonColor = UIView().tintColor ?? .black
}

extension UIImageView { // Credits to https://stackoverflow.com/a/35317253
    @IBInspectable var shouldAdjustHeight: Bool {
        get {
            return self.frame.size.height == self.adjustedHeight
        }
        set {
            if newValue {
                if !shouldAdjustHeight {
                    let newHeight = self.adjustedHeight
                    
                    // add constraint to adjust height
                    self.addConstraint(NSLayoutConstraint(
                        item:self, attribute:NSLayoutAttribute.height,
                        relatedBy:NSLayoutRelation.equal,
                        toItem:nil, attribute:NSLayoutAttribute.notAnAttribute,
                        multiplier:0, constant:newHeight))
                }
            } else {
                let newHeight = self.adjustedHeight
                // create predicate to find the height constraint that we added
                let predicate = NSPredicate(format: "%K == %d && %K == %f", "firstAttribute", NSLayoutAttribute.height.rawValue, "constant", newHeight)
                // remove constraint
                self.removeConstraints(self.constraints.filter{ predicate.evaluate(with: $0) })
            }
        }
    }
    
    var adjustedHeight: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let deviceScaleFactor = screenWidth/self.bounds.size.width
        return CGFloat(ceilf(Float(deviceScaleFactor * AVMakeRect(aspectRatio:(self.image?.size) ?? CGSize.zero, insideRect: self.bounds).size.height))) // deviceScaleFactor multiplied with the image size for the frame
        
        // I am using size class in my XIB with value as (Any,Any) and I was not getting correct frame values for a particular device so I have used deviceScaleFactor.
        // You can modify above code to calculate newHeight as per your requirement
    }
}
