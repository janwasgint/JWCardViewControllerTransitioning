//
//  MainViewController.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 12.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var sampleSelectionTableView: UITableView! { didSet { sampleSelectionTableView.style() } }
    
    let samples = [("Presenting a card", #selector(presentCard)),
                   ("Presenting a card in a navigation controller", #selector(presentNavigationController)),
                   ("Presenting multiple cards", #selector(presentMultipleCards))]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        JWDrawerCardNavigationControllerDelegate.addDrawerCard(inNavigationController: navigationController!,
                                                               drawerViewController: self,
                                                               cardViewController: storyboard!.instantiateViewController(withIdentifier: .cardIdentifier),
                                                               drawerTitle: "Drawer Test")
    }
}

//MARK: TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return samples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell().style()
        cell.textLabel?.text = samples[indexPath.row].0
        return cell
    }
}

//MARK: TableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        perform(samples[indexPath.row].1)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: ViewController presentations
extension MainViewController {
    @objc func presentCard() {
        if let cardViewController = storyboard?.instantiateViewController(withIdentifier: .cardIdentifier) {
            navigationController?.pushViewController(cardViewController, animated: true)
        }
    }
    
    @objc func presentNavigationController() {
        if let navigationViewController = storyboard?.instantiateViewController(withIdentifier: .navigationControllerIdentifier) {
            present(navigationViewController, animated: true)
        }
    }
    
    @objc func presentMultipleCards() {
        if let multipleCardsViewController = storyboard?.instantiateViewController(withIdentifier: .multipleCardsIdentifier) {
            navigationController?.pushViewController(multipleCardsViewController, animated: true)
        }
    }
}
