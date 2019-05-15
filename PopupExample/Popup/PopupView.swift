//
//  PopupView.swift
//  PopupExample
//
//  Created by osanai on 2019/05/14.
//  Copyright © 2019 osanai. All rights reserved.
//

// 使用例 1
//
// _ = PopupView.create(innerView: hogeView)
//              .addClseIcon(at: .left)
//              .setTapOutsideActionMode(tapOutsideActionMode: .close)
//              .tapOutsideAction {
//                  print("🙂")
//              }
//              .show(in: view.window!)

// 使用例 2
//
// let popupView = PopupView.create(innerView: hogeView, position: .right, tapOutsideActionMode: PopupView.TapOutsideActionMode.close)
// _ = popupView.show(in: view.window!)


import UIKit

final class PopupView: UIControl {

    var duration: TimeInterval = 0.3
    var innerView: UIView?

    /// 外側をタップした時の挙動
    enum TapOutsideActionMode {
        case close          // 閉じる
        case nothingToDo    // 何もしない
    }
    var tapOutsideActionMode: TapOutsideActionMode = .nothingToDo

    /// 閉じるボタンの場所
    enum CloseIconPosition {
        case left
        case right
        case none
    }
    var closeIconPosition: CloseIconPosition = .none
    var closeIconControl: UIControl!

    // MARK: - Option

    /// 閉じる以外に何かする場合
    var tapOutsideAction: (() -> Void)?

    // MARK: - Creation

    func setup(innerView: UIView) {
        self.innerView = innerView
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        innerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        innerView.isUserInteractionEnabled = true

        addTarget(self, action: #selector(tapped(_ :)), for: .touchUpInside)
    }

    static func create(innerView: UIView) -> PopupView {
        let popupView = PopupView(frame: UIApplication.shared.keyWindow?.bounds ?? .zero)
        popupView.setup(innerView: innerView)
        return popupView
    }
    static func create(innerView: UIView, position: CloseIconPosition, tapOutsideActionMode: TapOutsideActionMode) -> PopupView {
        let popupView = PopupView(frame: UIApplication.shared.keyWindow?.bounds ?? .zero)
        popupView.setup(innerView: innerView)

        popupView.closeIconPosition = position
        popupView.addCloseIcon()
        popupView.tapOutsideActionMode = tapOutsideActionMode

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

    func closeButtonImageView() -> UIImageView {
        return UIImageView(image: UIImage(named: "btn_close"), contentMode: .center)
    }

    func addCloseIcon() {
        guard let innerView = innerView else {
            return
        }
        guard closeIconPosition != .none else {
            return
        }

        closeIconControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = closeButtonImageView()
        closeIconControl.addSubview(imageView)
        imageView.bindFrameToSuperviewBounds()
        addSubview(closeIconControl)

        closeIconControl.translatesAutoresizingMaskIntoConstraints = false
        if closeIconPosition == .left {
            closeIconControl.centerXAnchor.constraint(equalTo: innerView.leadingAnchor).isActive = true
            closeIconControl.centerYAnchor.constraint(equalTo: innerView.topAnchor).isActive = true
        }
        if closeIconPosition == .right {
            closeIconControl.centerXAnchor.constraint(equalTo: innerView.trailingAnchor).isActive = true
            closeIconControl.centerYAnchor.constraint(equalTo: innerView.topAnchor).isActive = true
        }
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

// MARK: Utility

extension UINib {
    static func create(nibName: String, owner: Any?) -> UIView? {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: owner, options: nil).first as? UIView
    }
}
