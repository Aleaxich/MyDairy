////
////  testRXSwiftViewController.swift
////  MyDairy
////
////  Created by 匿名用户的笔记本 on 2023/4/22.
////  Copyright © 2023 匿名用户的笔记本. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import Then
//
///*
// ?
// 设置界面 < - > model < - > textView
// 1.完成按钮到 model
//
// */
//
//
//public class rxTextModel: NSObject{
////    var textColor:UIColor = .black
//    var modelColor = UIColor.white
//    lazy var textColor = BehaviorSubject(value:modelColor)
//    
////    override init() {
////        super.init()
////        startKVO()
////    }
//    
////    func startKVO() {
////        textColor =
////    }
//}
//
//
//
//
//
//
//class testRXSwiftViewController: UIViewController {
//    
//    let bag = DisposeBag()
////    let textModel = textModel.init()
//    lazy var textModel = rxTextModel()
//    
//    lazy var button1 = UIButton()
//    lazy var button2 = UIButton()
//    lazy var button3 = UIButton()
//    lazy var textView = UITextView()
//    
////    lazy var modelData:Driver<rxTextModel> = {
////        return self.textModel.textColor.asObservable()
////
//////            .throttle(0.3, scheduler: MainScheduler.instance)
////            .distinctUntilChanged()
////            .asDriver()
//////            .asDriver(onErrorJustReturn: rxTextModel())
////    }()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        button1.isSelected = true
//        setupSubviews()
//
//        
//        let buttons = [button1,button2,button3]
//        let selectedButton = Observable.from(
//            buttons.map({ button in
//                button.rx.tap.map {
//                    button
//                }
//            })
//        ).merge()
//        
//
//        for button in buttons {
//            selectedButton.map { $0 == button }
//                .bind(to: button.rx.isSelected)
//                .disposed(by: bag)
//        }
//        
//        selectedButton.map {
//            $0.backgroundColor!
//        }.bind(to:textModel.textColor)
//            .disposed(by: bag)
//        
////        for button in buttons {
////            selectedButton.map { _ in button.backgroundColor! }
////                .bind(to: textModel.textColor)
////                .disposed(by: bag)
////        }
//        
//        
//        // 这种方法可以实现订阅
////        textModel.textColor.subscribe{ (event) in
////            self.view.backgroundColor = event
////        }.disposed(by: bag)
//        
//        
//        self.textModel.textColor.drive(self.view.rx.backgroundColor)
//            .disposed(by: bag)
////
////        textModel.textColor.onNext(UIColor.red)
//        
//        
//        
//
//        
//        
//        
//    }
//    
//    func setupSubviews() {
//        self.view.backgroundColor = .white
//        
//        
//        view.addSubview(textView)
//        textView.snp.makeConstraints { (maker) in
//            maker.centerX.equalToSuperview()
//            maker.top.equalToSuperview().offset(200)
//            maker.size.equalTo(CGSize(width: 300, height: 500))
//        }
//        
//        button1.setTitle("10", for: .normal)
//        button1.backgroundColor = .yellow
//        button1.setTitleColor(UIColor.black, for: .normal)
//        button1.setTitleColor(UIColor.red, for: .selected)
//        button2.setTitle("20", for: .normal)
//        button2.setTitleColor(UIColor.black, for: .normal)
//        button2.setTitleColor(UIColor.red, for: .selected)
//        button2.backgroundColor = .green
//        button3.setTitle("30", for: .normal)
//        button3.setTitleColor(UIColor.black, for: .normal)
//        button3.setTitleColor(UIColor.red, for: .selected)
//        button3.backgroundColor = .purple
//        
//        
//
//        view.addSubview(button1)
//        view.addSubview(button2)
//        view.addSubview(button3)
//        
//        let stackView = UIStackView.init()
//              stackView.axis = .horizontal
//              stackView.alignment = .fill
//              stackView.spacing = 10
//              stackView.distribution = .fillEqually
//              stackView.addArrangedSubview(button1)
//              stackView.addArrangedSubview(button2)
//              stackView.addArrangedSubview(button3)
//        view.addSubview(stackView)
//        stackView.snp.makeConstraints { (maker) in
//            maker.centerX.equalToSuperview()
//            maker.top.equalToSuperview().offset(100)
//            maker.size.equalTo(CGSize(width: 300, height: 50))
//        }
//
//
//    }
//    
//    
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//
//extension Reactive where Base:UITextView {
//    public var textColor:Binder<UIColor> {
//        return Binder(self.base) { textView,color in
//            textView.textColor = color
//        }
//    }
//}
//
//extension Reactive where Base:UIView {
//    public var backgroundColor:Binder<UIColor> {
//        return Binder(self.base) { view,color in
//            view.backgroundColor = color
//        }
//    }
//}
//
//
//extension Reactive where Base:rxTextModel {
//    public var textColor:Binder<UIColor> {
//        return Binder(self.base) { model,color in
//            model.textColor = color
//        }
//    }
//}
