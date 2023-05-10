//
//  MDPicturesViewCell.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/12.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Then


class RXButton:UIButton {
    
    var showAnimation:(() -> ())?
    
    lazy var bag = DisposeBag()
    
    override var isHidden: Bool {
        didSet {
            if !isHidden {
                guard let action = self.showAnimation else { return }
                action()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        kvo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func kvo() {
        self.rx.observeWeakly(Bool.self, "isHidden")
            .subscribe {[weak self] hidden in
                if !hidden! {
                    guard let action = self?.showAnimation else { return }
                    action()
                }
            }.disposed(by: bag)
    }
}

class MDPicturesViewCell:UICollectionViewCell, CAAnimationDelegate {
    
    lazy var picView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    var deleteButton:RXButton
    
    var deleteAction:(() -> ())?
    
    /// 隐藏按钮
    var clickHiddenButton:(() -> ())?
    
    /// 展示删除按钮
    var showButton:(() -> ())?
    
    let bag = DisposeBag()
    
    var buttonHidden = false
    
    
    
    override init(frame: CGRect) {
        deleteButton = RXButton(frame: .zero)
        super.init(frame: frame)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPress.minimumPressDuration = 0.5
        contentView.addGestureRecognizer(longPress)
      
        let click = UITapGestureRecognizer(target: self, action: #selector(clickButton))
        contentView.addGestureRecognizer(click)
        
        deleteButton.rx
                 .tap
                 .subscribe(onNext: { [weak self] in
                     guard let action = self?.deleteAction else { return }
                     action()
                 }).disposed(by: bag)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews(){
        deleteButton.setBackgroundImage(UIImage(named:"icon_red_close"), for: .normal)
        deleteButton.isHidden = true
        deleteButton.layer.cornerRadius = 20
        deleteButton.layer.masksToBounds = true
        deleteButton.showAnimation = {[weak self] in
            self!.deleteButton.layer.add(self!.shakeAnimate(repeatCount: MAXFLOAT, duration: 0.2, values: [-M_PI/12, M_PI/12,-M_PI/12]), forKey: nil)
        }
        
        self.contentView.addSubview(picView)
        picView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.picView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
    
     @objc private func longPress(gesture:UILongPressGestureRecognizer) {
        if gesture.state == .began {
            deleteButton.isHidden = false
            guard let action = showButton else { return }
            action()
        }
    }
    
    @objc private func clickButton() {
        guard !deleteButton.isHidden else { return }
        deleteButton.isHidden = true
        buttonHidden = true
        guard let action = clickHiddenButton else { return }
        action()
    }
    
    func loadData(_ imageData:NSData,hiddenButton:Bool) {
        picView.image = UIImage(data: imageData as Data)
        deleteButton.isHidden = hiddenButton
        buttonHidden = hiddenButton
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("点击")
        return super.hitTest(point, with: event)
    }
    
    func shakeAnimate(repeatCount:Float,duration:CFTimeInterval,values:[Any]) -> CAKeyframeAnimation {
        let keyAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        keyAnimation.delegate = self
        keyAnimation.beginTime = CACurrentMediaTime()
        keyAnimation.duration = duration
        keyAnimation.values = values
        keyAnimation.repeatCount = repeatCount
        keyAnimation.isRemovedOnCompletion = true
        return keyAnimation
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.deleteButton.layer.removeAnimation(forKey: "transform.rotation")
        }
    }
    
    

}
