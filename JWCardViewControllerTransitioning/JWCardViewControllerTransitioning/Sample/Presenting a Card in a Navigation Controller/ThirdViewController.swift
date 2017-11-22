//
//  ThirdViewController.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 18.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func popViewControllerButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
