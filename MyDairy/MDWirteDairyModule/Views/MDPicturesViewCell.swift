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

class MDPicturesViewCell:UICollectionViewCell {
    
    lazy var picView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    lazy var deleteButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named:"icon_red_close"), for: .normal)
        $0.isHidden = true
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    var deleteAction:(()->())?
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPress.minimumPressDuration = 1
        contentView.addGestureRecognizer(longPress)

        
        deleteButton.rx
                 .tap
                 .subscribe(onNext: { [weak self] in
                     guard let action = self?.deleteAction else { return }
                     action()
                 }).disposed(by: disposeBag)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews(){
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
        }
    }
    
    func loadData(_ imageData:NSData) {
        picView.image = UIImage(data: imageData as Data)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("点击")
        return super.hitTest(point, with: event)
    }
}
