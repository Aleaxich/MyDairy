//
//  MDWriteNoteSettingViewController.swift
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/20.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

import Foundation

final class MDWriteNoteSettingPopover: MDBasePopover,UITableViewDataSource,UITableViewDelegate {
    var viewModel:MDWriteNoteSettingViewModel
    var tableView:UITableView
    init(mdtextview textview:MDTextView,frame:CGRect) {
        tableView = UITableView.init(frame: .zero, style: .plain)
        viewModel = MDWriteNoteSettingViewModel.init(textView: textview.textView)
        super.init()
        buildSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildSubview() {
        tableView.register(MDWriteNoteSettingCell.self, forCellReuseIdentifier: NSStringFromClass(MDWriteNoteSettingCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.height.equalTo(300)
            maker.bottom.width.centerX.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.settingItemList.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MDWriteNoteSettingCell.self)) as! MDWriteNoteSettingCell
            cell.loadDataWithType(type: self.viewModel.settingItemList[indexPath.row])
        return cell
       }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            0.001
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            60
    }
    
}
