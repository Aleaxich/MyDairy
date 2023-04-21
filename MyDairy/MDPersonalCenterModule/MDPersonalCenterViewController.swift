//
//  MDPersonalCenterViewController.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/4/16.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation
import Then

@objcMembers class MDPersonalCenterViewController : MDBaseViewController {

    lazy var tableView = UITableView.init(frame: .zero, style: .plain)
    
    /// 数据源
    lazy var dataSource:[MDPersonalCenterSettingItemModel] = []
    
    var nav:UINavigationController?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        setupSubviews()
        createDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func createDataSource() {
        /// 照片墙
        let photoWallCell = MDPersonalCenterSettingItemModel(title: "照片墙", selectedAction: { [weak self] in
            let vc = MDPhotoWallViewController()
            self?.present(vc, animated: true)
        })
        dataSource.append(photoWallCell)
        tableView.reloadData()
    }

    func setupSubviews() {
        setupCustomNavBar()
        self.setNavLeftButtonTitle("", with: UIImage(named: "icon_orange_close")!) {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.backgroundColor = .white
        tableView.register(MDPersonalCenterItemCell.self, forCellReuseIdentifier: NSStringFromClass(MDPersonalCenterItemCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(100)
            make.bottom.equalToSuperview()
        }
    }
}

extension MDPersonalCenterViewController:UITableViewDelegate,UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MDPersonalCenterItemCell.self)) as! MDPersonalCenterItemCell
        cell.loadData(model: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.001
    }
}
