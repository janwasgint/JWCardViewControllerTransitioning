//
//  JWDrawerCardNavigationControllerDelegate.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 24.05.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class JWDrawerCardNavigationControllerDelegate: JWCardNavigationControllerDelegate {
    static var drawer: UIView?
    static let drawerToolBarHeight: CGFloat = 70
    
    static var drawerViewController: UIViewController?
    static var cardViewController: UIViewController?
    static var navigationController: UINavigationController?
    static var showingCard = false
    
    
    // Limit to 1 card
    override func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if cardAnimator.depth() == 0 && operation == .push {
            JWDrawerCardNavigationControllerDelegate.cardViewController = toVC
            JWDrawerCardNavigationControllerDelegate.push()
            return super.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        } else if cardAnimator.depth() == 1 && operation == .pop {
            JWDrawerCardNavigationControllerDelegate.drawerViewController = toVC
            JWDrawerCardNavigationControllerDelegate.pop()
            return super.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        } else {
            return nil
        }
    }
}

extension JWDrawerCardNavigationControllerDelegate { //Mark: Static setup
    // Instantiate a drawer, not a card controller delegate
    class func addDrawerCard(inNavigationController navigationController: UINavigationController,
                             drawerViewController: UIViewController,
                             cardViewController: UIViewController,
                             drawerTitle: String) {
        if (navigationController.delegate as? JWDrawerCardNavigationControllerDelegate == nil) {
            let navigationControllerDelegate = JWDrawerCardNavigationControllerDelegate()
            navigationController.delegate = navigationControllerDelegate
            
            navigationController.interactivePopGestureRecognizer?.delegate = navigationControllerDelegate
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationControllerDelegates.append(navigationControllerDelegate)
            
            self.cardViewController = cardViewController
            self.drawerViewController = drawerViewController
            self.navigationController = navigationController
            
            addDrawer(to: drawerViewController.view, withTitle: drawerTitle)
        }
    }
}

extension JWDrawerCardNavigationControllerDelegate {
    fileprivate class func push() {
        if let drawer = self.drawer, let cardView = cardViewController?.view {
            drawer.removeFromSuperview()
            let drawerToolBarFrame = CGRect(x: -1, y: 0, width: cardView.frame.width + 2, height: drawerToolBarHeight)
            drawer.frame = drawerToolBarFrame
            cardView.addSubview(drawer)
        }
        showingCard = true
    }
    
    fileprivate class func pop() {
        if let drawer = self.drawer, let drawerView = drawerViewController?.view {
            drawer.removeFromSuperview()
            let drawerToolBarFrame = CGRect(x: -1, y: drawerView.frame.height - drawerToolBarHeight, width: drawerView.frame.width + 2, height: drawerToolBarHeight)
            drawer.frame = drawerToolBarFrame
            drawerView.addSubview(drawer)
        }
        showingCard = false
    }
}

extension JWDrawerCardNavigationControllerDelegate {
    fileprivate class func addDrawer(to view: UIView, withTitle title: String) {
        // drawer
        let drawerToolBarFrame = CGRect(x: -1, y: view.frame.height - drawerToolBarHeight, width: view.frame.width + 2, height: drawerToolBarHeight)
        let drawerToolBar = UIView(frame: drawerToolBarFrame)
        drawerToolBar.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 0.8)
        drawerToolBar.layer.borderColor = UIColor.gray.cgColor
        drawerToolBar.layer.borderWidth = 1
        view.addSubview(drawerToolBar)
        
        // title label
        let drawerTitleOffset: CGFloat = 20
        let drawerTitleLabelHeight: CGFloat = 50
        let drawerTitleFrame = CGRect(x: drawerTitleOffset, y: (drawerToolBarHeight - drawerTitleLabelHeight) * 0.5, width: view.frame.width - 2 * drawerTitleOffset, height: drawerTitleLabelHeight)
        let drawerTitleLabel = UILabel(frame: drawerTitleFrame)
        drawerTitleLabel.text = title
        drawerToolBar.addSubview(drawerTitleLabel)
//        drawerTitleLabel.centerYAnchor.constraint(equalTo: drawerToolBar.centerYAnchor).isActive = true
//        drawerTitleLabel.leftAnchor.constraint(equalTo: drawerToolBar.leftAnchor).isActive = true
//        drawerTitleLabel.rightAnchor.constraint(equalTo: drawerToolBar.rightAnchor).isActive = true
//        drawerTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        drawerToolBar.layoutIfNeeded()
        
        // gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(drawerTapped))
        drawerToolBar.addGestureRecognizer(tapGestureRecognizer)
                
        drawer = drawerToolBar
    }
    
    @objc class func drawerTapped() {
        if let cardViewController = self.cardViewController, showingCard == false {
            navigationController?.pushViewController(cardViewController, animated: true)
        }
    }
    
    
    fileprivate func addTopHandleView(to view: UIView) {
        let handleViewTopMargin: CGFloat = 10
        let handleViewWidth: CGFloat = 50
        let handleViewHeight: CGFloat = 10
        
        let handleViewFrame = CGRect(x: (view.frame.width - handleViewWidth) * 0.5,
                                     y: JWCardAnimationConstants.cardMarginToTop + handleViewTopMargin,
                                     width: handleViewWidth,
                                     height: handleViewHeight)
        let handleView = UIView(frame: handleViewFrame)
        
        handleView.backgroundColor = .red
        view.addSubview(handleView)
        handleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        handleView.widthAnchor.constraint(equalToConstant: handleViewWidth).isActive = true
        handleView.heightAnchor.constraint(equalToConstant: handleViewHeight).isActive = true
        
        view.layoutIfNeeded()
        handleView.layoutIfNeeded()
        
    }
}
