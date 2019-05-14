//
//  ViewController.swift
//  PopupExample
//
//  Created by osanai on 2019/05/14.
//  Copyright © 2019 osanai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func tappedButton(_ sender: Any) {

        let popup = PopupView.create(innerView: UINib(nibName: "PopupA", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView)
            .addClseIcon(at: .left)
            .setTapOutsideActionMode(tapOutsideActionMode: .close)
            .show(in: view.window!)
            .tapOutsideAction {
                print("😭")
        }


//        PopupView.create(innerView: UINib(nibName: "PopupA", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
//
//        PopupView.create(innerView: UINib(nibName: "PopupA", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView,
//                         closeIconPosition: .none,
//                         tapAction:  {
//
//        }).addAndShow(in: view.window!)

//        let popupView:PopupView = UINib(nibName: "PopupView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PopupView
//        let v = UIView(frame: self.view.window!.bounds)
//        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
//        v.addSubview(popupView)
//        popupView.translatesAutoresizingMaskIntoConstraints = true
//        popupView.center = v.center
//
//        v.alpha = 0
//        self.view.window?.addSubview(v)
//        UIView.animate(withDuration: 0.3) {
//            v.alpha = 1
//        }



    }




}

