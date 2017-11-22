//
//  SecondViewController.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 18.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JWCardNavigationControllerDelegate.startPresentingViewControllersAsCards(inNavigationController: navigationController!)
    }
    
    @IBAction func popViewControllerButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


