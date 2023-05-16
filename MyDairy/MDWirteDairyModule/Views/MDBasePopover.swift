//
//  MDBasePopover.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/19.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

typealias selectedAction = (String) -> ()


@objcMembers class MDBasePopover: UIView, UIGestureRecognizerDelegate {
    
    var selectedAction:selectedAction?

   
        init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH_SWIFT, height: SCREENH_HEIGHT_SWIFT))
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        self.isUserInteractionEnabled = true
        gesture.delegate = self
        self.addGestureRecognizer(gesture)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func cancelAction() {
      
    }
      
    func confirmAction() {
     
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isKind(of: MDBasePopover.self) {
            return true
        }
         return false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitview = super.hitTest(point, with: event)
        if hitview == self {
            dismiss()
            return nil
        } else {
            return hitview
        }
    }
    
    
    func show() {
        let window = UIApplication.shared.windows.first(where: \.isKeyWindow)
        window!.addSubview(self)
        window!.bringSubviewToFront(self)
        self.frame.origin.y = SCREENH_HEIGHT_SWIFT
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layer.opacity = 1
            self.frame.origin.y = 0
        }, completion: nil)
    }

    @objc func dismiss(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.layer.opacity = 0
            self.frame.origin.y = SCREENH_HEIGHT_SWIFT
        }) { (finished) in
            self.removeFromSuperview()
        }
    }

}


