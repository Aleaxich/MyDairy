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

class MDPicturesViewCell:UICollectionViewCell, CAAnimationDelegate {
    
    lazy var picView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    var deleteButton:UIButton
    
    var deleteAction:(() -> ())?
    
    /// 隐藏按钮
    var dismissDeleteButton:(() -> ())?
    
    /// 展示删除按钮
    var showDeleteButton:(() -> ())?
    
    let bag = DisposeBag()
    
    override init(frame: CGRect) {
        deleteButton = UIButton(frame: .zero)
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
        deleteButton.layer.cornerRadius = 20
        deleteButton.layer.masksToBounds = true
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
            guard let action = showDeleteButton else { return }
            action()
        }
    }
    
    @objc private func clickButton() {
        guard let action = dismissDeleteButton else { return }
        action()
    }
    
    func loadData(_ imageData:NSData) {
        picView.image = UIImage(data: imageData as Data)

    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("点击")
        return super.hitTest(point, with: event)
    }
    
    func animationDidStart(_ anim: CAAnimation) {
           print("md开始动画")
       }
       
       func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
           
           #warning("md如果不是完成动画，而是被停止动画，则 flag 为 false")
           if flag {
               print("md动画完成")
           } else {
               print("md动画被停止")
           }
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
    
    func startAnimation() {
        deleteButton.isHidden = false
//        deleteButton.layer.add(self.shakeAnimate(repeatCount: MAXFLOAT, duration: 0.2, values: [-Double.pi/12, Double.pi/12,-Double.pi/12]), forKey: nil)
    }
    

    func stopAnimation() {
        deleteButton.isHidden = true
//        deleteButton.layer.removeAnimation(forKey: "transform.rotation")
    }
}
