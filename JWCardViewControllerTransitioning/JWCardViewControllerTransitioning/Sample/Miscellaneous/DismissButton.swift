//
//  DismissButton.swift
//  JWCardViewControllerTransitioning
//
//  Created by Jan Wasgint on 18.11.17.
//  Copyright © 2017 Jan Wasgint. All rights reserved.
//

import UIKit

class DismissButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.systemButtonColor.cgColor
    }
}
