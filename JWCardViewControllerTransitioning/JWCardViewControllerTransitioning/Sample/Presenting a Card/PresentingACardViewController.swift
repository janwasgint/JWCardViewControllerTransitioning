//
//  PresentingACardViewController.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 17.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class PresentingACardViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
