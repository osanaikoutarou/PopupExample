//
//  ViewController.swift
//  PopupExample
//
//  Created by osanai on 2019/05/14.
//  Copyright © 2019 osanai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toggleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func tappedButton(_ sender: Any) {
        createAndShow1()
    }

    func popupInnerView() -> UIView {
        return UINib.create(nibName: "PopupA", owner: self)!
    }

    func createAndShow1() {
        _ = PopupView.create(innerView: popupInnerView())
            .addClseIcon(at: .left)
            .setTapOutsideActionMode(tapOutsideActionMode: .close)
            .tapOutsideAction {
                print("🙂")
            }
            .show(in: view.window!)
    }

    func createAndShow2() {
        let popupView = PopupView.create(innerView: popupInnerView(), position: .right, tapOutsideActionMode: PopupView.TapOutsideActionMode.close)
        _ = popupView.show(in: view.window!)
    }

    @IBAction func tapped(_ sender: Any) {
        toggleLabel.text = (toggleLabel.text == "Cat") ? "Dog" : "Cat"
    }



}

