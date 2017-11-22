//
//  PresentingMultipleCardsViewController.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 19.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class PresentingMultipleCardsViewController: UIViewController {
    var index: Int?
    @IBOutlet weak var titleDetailLabel: UILabel!
    
    @IBOutlet weak var popButton: UIButton!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = index {
            titleDetailLabel.text = "VIEWCONTROLLER #\(index)"
        }
        if navigationController?.depthOfViewControllerInNavigationStack(viewController: self) == 0 {
            popButton.titleLabel?.text = "Dismiss"
        }
    }
    
    @IBAction func pushButtonPressed(_ sender: Any) {
        if let nextCardViewController = storyboard?.instantiateInitialViewController() as? PresentingMultipleCardsViewController {
            if let index = index {
                nextCardViewController.index = index + 1
            } else {
                nextCardViewController.index = 1
            }
            navigationController?.pushViewController(nextCardViewController, animated: true)
        }
    }
    
    @IBAction func popButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
