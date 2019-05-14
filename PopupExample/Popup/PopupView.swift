//
//  PopupView.swift
//  PopupExample
//
//  Created by osanai on 2019/05/14.
//  Copyright © 2019 osanai. All rights reserved.
//

import UIKit

class PopupView: UIControl {

    let duration: TimeInterval = 0.3

    @IBOutlet weak var containerControl: UIControl!

    var innerView: UIView?

    /// 外側をタップした時
    enum TapOutsideActionMode {
        case close          // 閉じる
        case nothingToDo    // 何もしない
    }
    var tapOutsideActionMode: TapOutsideActionMode = .nothingToDo

    var tapOutsideAction: (() -> Void)?

    /// 閉じるボタンの場所
    enum CloseIconPosition {
        case left, right, none
    }
    var closeIconPosition: CloseIconPosition = .none
    var closeIconControl: UIControl!

    // MARK: -

    func setup(innerView: UIView) {
        self.innerView = innerView

        if let window = UIApplication.shared.delegate?.window {
            frame = window?.bounds ?? .zero
        }
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        containerControl.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = true
        innerView.center = containerControl.center
        innerView.isUserInteractionEnabled = true
    }

    static func create(innerView: UIView) -> PopupView {
        let popupView: PopupView = UINib(nibName: "PopupView", bundle: nil).instantiate(withOwner: self, options: nil).first as! PopupView
        popupView.setup(innerView: innerView)
        return popupView
    }
    func addClseIcon(at position:CloseIconPosition) -> PopupView {
        closeIconPosition = position
        addCloseIcon()
        return self
    }
    func tapOutsideAction(tapOutsideAction: @escaping () -> Void) -> PopupView {
        self.tapOutsideAction = tapOutsideAction
        return self
    }
    func setTapOutsideActionMode(tapOutsideActionMode: TapOutsideActionMode) -> PopupView {
        self.tapOutsideActionMode = tapOutsideActionMode
        return self
    }
    func show(in view:UIView) -> PopupView {
        view.addSubview(self)
        fadein(completion: nil)
        return self
    }
    func close() {
        fadeout { (finished) in
            self.removeFromSuperview()
        }
    }

    @IBAction func tapped(_ sender: Any) {
        if tapOutsideActionMode == .close {
            close()
        }
        tapOutsideAction?()
    }

}

extension PopupView {


    func addCloseIcon() {
        guard let innerView = innerView else {
            return
        }
        closeIconControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        closeIconControl.addSubviewAndBind(view: UIImageView(image: UIImage(named: "btn_close"), contentMode: .center))

        containerControl.addSubview(closeIconControl)
        closeIconControl.translatesAutoresizingMaskIntoConstraints = true
        closeIconControl.center = innerView.frame.origin
        closeIconControl.addTarget(self, action: #selector(tappedCloseButton), for: UIControl.Event.touchUpInside)
    }

    @objc func tappedCloseButton(sender: Any) {
        close()
    }
}

extension PopupView {
    func fadein(completion: ((_ finished: Bool) -> Void)?) {
        alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    func fadeout(completion: ((_ finished: Bool) -> Void)?) {
        alpha = 1
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}

private extension UIImageView {
    convenience init(image: UIImage?, contentMode: ContentMode) {
        self.init(image: image)
        self.contentMode = contentMode
    }
}
private extension UIView {
    func addSubviewAndBind(view: UIView) {
        addSubview(view)
        view.bindFrameToSuperviewBounds()
    }

    @objc
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
    }
}
