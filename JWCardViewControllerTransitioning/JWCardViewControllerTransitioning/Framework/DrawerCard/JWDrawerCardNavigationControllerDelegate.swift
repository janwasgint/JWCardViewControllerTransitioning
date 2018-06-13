//
//  JWDrawerCardNavigationControllerDelegate.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 24.05.18.
//  Copyright © 2018 Jan Wasgint. All rights reserved.
//

import UIKit

class JWDrawerCardNavigationControllerDelegate: JWCardNavigationControllerDelegate {
    static var drawer: JWTouchableUIView?
    static var drawerTitleLabel: UILabel?
    static var drawerOffset: CGFloat = 0
    static let drawerToolBarHeight: CGFloat = 70
    static let drawerColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    
    static var drawerViewController: UIViewController?
    static var cardViewController: UIViewController?
    static var navigationController: UINavigationController?
    static var showingCard = false
    
    static var drawerCardInteractionController: JWDrawerCardInteractionController?
    
    static var snapshotOfTabbar: UIView?
    
    static var tabBar: UITabBar? = { () -> UITabBar? in
        if let drawerViewController = JWDrawerCardNavigationControllerDelegate.drawerViewController {
            if let unwrappedTabBar = drawerViewController.tabBarController?.tabBar {
                return unwrappedTabBar
            } else {
                if drawerViewController.childViewControllers.count > 0 {
                    if let unwrappedTabBar = drawerViewController.childViewControllers.first?.tabBarController?.tabBar {
                        return unwrappedTabBar
                    }
                }
            }
        }
        return nil
    }()
    
    init() {
        let tabBarHeight: CGFloat = JWDrawerCardNavigationControllerDelegate.tabBar?.frame.height ?? (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        
        
        JWDrawerCardNavigationControllerDelegate.drawerOffset = tabBarHeight
        
        
        print("safe area insets \(String(describing: UIApplication.shared.keyWindow?.safeAreaInsets.bottom))")
        super.init(offsetToBottom: JWDrawerCardNavigationControllerDelegate.drawerToolBarHeight + JWDrawerCardNavigationControllerDelegate.drawerOffset)
    }
    
    // Limit to 1 card
    override func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if cardAnimator.depth() == 0 && operation == .push {
            JWDrawerCardNavigationControllerDelegate.cardViewController = toVC
            JWDrawerCardNavigationControllerDelegate.push()
            return super.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
        } else if cardAnimator.depth() == 1 && operation == .pop {
//            JWDrawerCardNavigationControllerDelegate.drawerViewController = toVC
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
//        if (navigationController.delegate as? JWDrawerCardNavigationControllerDelegate == nil) {
            self.cardViewController = cardViewController
            self.drawerViewController = drawerViewController
            self.navigationController = navigationController
            
            let navigationControllerDelegate = JWDrawerCardNavigationControllerDelegate()
            navigationController.delegate = navigationControllerDelegate
            
            navigationController.interactivePopGestureRecognizer?.delegate = navigationControllerDelegate
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationControllerDelegates.append(navigationControllerDelegate)
            
            addDrawer(to: navigationController.view, withTitle: drawerTitle)
            
            // comment this in to enable drawer panning (not fully working yet)
//            self.drawerCardInteractionController = JWDrawerCardInteractionController(drawerViewController: drawerViewController, cardViewController: cardViewController, drawer: drawer!)
//        }
    }
    
    class func setDrawerTitle(drawerTitle: String) {
        drawerTitleLabel?.text = drawerTitle
    }
}

extension JWDrawerCardNavigationControllerDelegate {
    fileprivate class func push() {
        if let tabBar = JWDrawerCardNavigationControllerDelegate.tabBar {
            let tabBarFrame = CGRect(x: tabBar.frame.minX, y: (drawerViewController?.view.frame.height ?? 0) - tabBar.frame.height, width: tabBar.frame.width, height: tabBar.frame.height)
            
            if let tabBarSnapshot = { () -> UIView? in
                let backgroundView = UIView(frame: tabBar.frame.offsetBy(dx: 0, dy: -tabBar.frame.minY))
                backgroundView.backgroundColor = UIColor(red: CGFloat(249.0/255.0), green: CGFloat(249.0/255.0), blue: CGFloat(249.0/255.0), alpha: 1)
                
                snapshotOfTabbar = backgroundView
                snapshotOfTabbar?.frame = tabBarFrame
                
                snapshotOfTabbar?.addSubview(tabBar.snapshotView(afterScreenUpdates: false) ?? UIView())
                return snapshotOfTabbar
            }() {
                navigationController?.view.addSubview(tabBarSnapshot)
                UIView.animate(withDuration: JWCardAnimationConstants.animationDuration) {
                    tabBarSnapshot.frame = tabBarSnapshot.frame.offsetBy(dx: 0, dy: tabBarSnapshot.frame.height)
                }
            }
        }
        
        if let drawer = self.drawer, let cardView = cardViewController?.view {
            let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(cardDrawnDown))
            downSwipeGestureRecognizer.direction = .down
            cardView.addGestureRecognizer(downSwipeGestureRecognizer)
            
            let drawerToolBarFrame = CGRect(x: -1, y: JWCardAnimationConstants.cardMarginToTop, width: cardView.frame.width + 2, height: drawerToolBarHeight)
            
            UIView.animate(withDuration: JWCardAnimationConstants.animationDuration, animations: {
                drawer.frame = drawerToolBarFrame
                drawer.backgroundColor = .white
                drawer.layer.cornerRadius = JWCardAnimationConstants.cornerRadius
                
                for subview in drawer.subviews {
                    subview.alpha = 0
                }
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (JWCardAnimationConstants.animationDuration * 2)/3) {
                UIView.animate(withDuration: JWCardAnimationConstants.animationDuration / 3) {
                    drawer.alpha = 0
                }
            }
        }
        showingCard = true
    }
    
    fileprivate class func pop() {
        if let tabBarSnapshot = snapshotOfTabbar {
            UIView.animate(withDuration: JWCardAnimationConstants.animationDuration, animations: {
                tabBarSnapshot.frame = tabBarSnapshot.frame.offsetBy(dx: 0, dy: -tabBarSnapshot.frame.height)
            }) { _ in
                tabBarSnapshot.removeFromSuperview()
                snapshotOfTabbar = nil
            }
        }
        
        if let drawer = self.drawer, let drawerView = drawerViewController?.view {
            let drawerToolBarFrame = CGRect(x: -1, y: drawerView.frame.height - drawerToolBarHeight - drawerOffset, width: drawerView.frame.width + 2, height: drawerToolBarHeight)
            
            UIView.animate(withDuration: JWCardAnimationConstants.animationDuration / 3) {
                drawer.alpha = 1
            }
            
            UIView.animate(withDuration: JWCardAnimationConstants.animationDuration) {
                drawer.frame = drawerToolBarFrame
                drawer.backgroundColor = drawerColor
                drawer.layer.cornerRadius = 0
                
                
                for subview in drawer.subviews {
                    if (subview.tag != JWTouchableUIView.pressedStateDarkeningViewTag) {
                        subview.alpha = 1
                    }
                }
            }
        }
        showingCard = false
    }
}

extension JWDrawerCardNavigationControllerDelegate {
    fileprivate class func addDrawer(to view: UIView, withTitle title: String) {
        // drawer
        let drawerToolBarStartFrame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: drawerToolBarHeight)
        let drawerToolBarFrame = CGRect(x: 0, y: view.frame.height - drawerToolBarHeight - drawerOffset, width: view.frame.width, height: drawerToolBarHeight)
        let drawerToolBar = JWTouchableUIView(frame: drawerToolBarStartFrame)
        drawerToolBar.backgroundColor = drawerColor
        view.addSubview(drawerToolBar)
        
        // tabbar snapshot
        if let tabBar = JWDrawerCardNavigationControllerDelegate.tabBar,
            let tabBarSnapshot = { () -> UIView? in
                let tabBarFrame = CGRect(x: tabBar.frame.minX, y: (drawerViewController?.view.frame.height ?? 0) - tabBar.frame.height, width: tabBar.frame.width, height: tabBar.frame.height)
                
                let backgroundView = UIView(frame: tabBar.frame.offsetBy(dx: 0, dy: -tabBar.frame.minY))
                backgroundView.backgroundColor = UIColor(red: CGFloat(249.0/255.0), green: CGFloat(249.0/255.0), blue: CGFloat(249.0/255.0), alpha: 1)
                
                snapshotOfTabbar = backgroundView
                snapshotOfTabbar?.frame = tabBarFrame
                
                snapshotOfTabbar?.addSubview(tabBar.snapshotView(afterScreenUpdates: false) ?? UIView())
                return snapshotOfTabbar
            }() {
            navigationController?.view.addSubview(tabBarSnapshot)
        }
        
        // drawer animation
        UIView.animate(withDuration: JWCardAnimationConstants.animationDuration, animations: {
            drawerToolBar.frame = drawerToolBarFrame
        }) { _ in
            snapshotOfTabbar?.removeFromSuperview()
            snapshotOfTabbar = nil
            drawerTapped()
        }
        
        // title label
        let drawerTitleOffset: CGFloat = 20
        let drawerTitleLabelHeight: CGFloat = 50
        let drawerTitleFrame = CGRect(x: drawerTitleOffset, y: (drawerToolBarHeight - drawerTitleLabelHeight) * 0.5, width: view.frame.width - 2 * drawerTitleOffset, height: drawerTitleLabelHeight)
        let drawerTitleLabel = UILabel(frame: drawerTitleFrame)
        drawerTitleLabel.text = title
        drawerToolBar.addSubview(drawerTitleLabel)
        self.drawerTitleLabel = drawerTitleLabel
        
        // separators
        let separatorThickness: CGFloat = 1
        let topSeparatorFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: separatorThickness)
        let bottomSeparatorFrame = CGRect(x: 0, y: drawerToolBarHeight - separatorThickness, width: view.frame.width, height: separatorThickness)
        let topSeparator = UIView(frame: topSeparatorFrame)
        let bottomSeparator = UIView(frame: bottomSeparatorFrame)
        topSeparator.backgroundColor = .gray
        bottomSeparator.backgroundColor = .gray
        drawerToolBar.addSubview(topSeparator)
        drawerToolBar.addSubview(bottomSeparator)
        
        
        // gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(drawerTapped))
        drawerToolBar.addGestureRecognizer(tapGestureRecognizer)
        
        let upSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(drawerTapped))
        upSwipeGestureRecognizer.direction = .up
        drawerToolBar.addGestureRecognizer(upSwipeGestureRecognizer)
        
        let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(drawerDrawDown))
        downSwipeGestureRecognizer.direction = .down
        drawerToolBar.addGestureRecognizer(downSwipeGestureRecognizer)
        
        drawer = drawerToolBar
    }
    
    @objc class func drawerTapped() {
        if let cardViewController = self.cardViewController, showingCard == false {
            navigationController?.pushViewController(cardViewController, animated: true)
        }
    }
    
    @objc class func cardDrawnDown() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc class func drawerDrawDown() {
        // tabbar snapshot
        if let tabBar = JWDrawerCardNavigationControllerDelegate.tabBar,
            let tabBarSnapshot = { () -> UIView? in
                let tabBarFrame = CGRect(x: tabBar.frame.minX, y: (drawerViewController?.view.frame.height ?? 0) - tabBar.frame.height, width: tabBar.frame.width, height: tabBar.frame.height)
                
                let backgroundView = UIView(frame: tabBar.frame.offsetBy(dx: 0, dy: -tabBar.frame.minY))
                backgroundView.backgroundColor = UIColor(red: CGFloat(249.0/255.0), green: CGFloat(249.0/255.0), blue: CGFloat(249.0/255.0), alpha: 1)
                
                snapshotOfTabbar = backgroundView
                snapshotOfTabbar?.frame = tabBarFrame
                
                snapshotOfTabbar?.addSubview(tabBar.snapshotView(afterScreenUpdates: false) ?? UIView())
                return snapshotOfTabbar
            }() {
            navigationController?.view.addSubview(tabBarSnapshot)
        }
        
        // animate drawer out
        UIView.animate(withDuration: JWCardAnimationConstants.animationDuration, animations: {
            drawer?.frame = drawer?.frame.offsetBy(dx: 0, dy: JWDrawerCardNavigationControllerDelegate.drawerOffset + (drawer?.frame.height ?? 0)) ?? CGRect.zero
        }) { _ in
            drawer?.removeFromSuperview()
            drawer = nil
            
            snapshotOfTabbar?.removeFromSuperview()
            snapshotOfTabbar = nil
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
