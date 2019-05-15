//
//  PopupA.swift
//  PopupExample
//
//  Created by osanai on 2019/05/15.
//  Copyright © 2019 osanai. All rights reserved.
//

import UIKit

class PopupA: UIView {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    @IBAction func tapped(_ sender: Any) {
        heightConstraint.constant = (heightConstraint.constant == 300) ? 200 : 300
        widthConstraint.constant = (widthConstraint.constant == 200) ? 100 : 200
        self.layoutIfNeeded()
        self.superview?.layoutIfNeeded()
    }


}
