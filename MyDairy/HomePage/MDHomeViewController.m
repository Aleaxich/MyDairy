//
//  MDHomeViewController.m
//  MyDairyAPP
//
//  Created by 匿名用户的笔记本 on 2023/3/13.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDHomeViewController.h"
#import "MDHomeViewModel.h"
#import "Masonry.h"
#import "MDHomeTableViewCell.h"
#import "MyDairy-Swift.h"
#import "UIViewController+MDCustomNavBar.h"




@interface MDHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) MDHomeViewModel *vm;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic ,strong) NSMutableArray<MDDairyCommonModel *>* datasource;

@end

@implementation MDHomeViewController

- (instancetype)init {
    if (self == [super init]) {
        self.vm = [[MDHomeViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildSubviews];
       
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
}

-(void)loadData {
    self.datasource = [self.vm getLocalFile];
    [self.tableview reloadData];
}

- (void)buildSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCustomNavBar];
    MDWeakSelf(self)
    [self setNavRightButtonTitle:@"" withImage:[UIImage imageNamed:@"icon_write_dairy"] withSelected:^{
        MDStrongSelf(self)
        MDWriteNoteViewController *vc = [[MDWriteNoteViewController alloc] initWithModel:self.vm.currentDateModel];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self setNavLeftButtonTitle:@"" withImage:[UIImage imageNamed:@"icon_personal_center"] withSelected:^{
        MDStrongSelf(self)
        MDPersonalCenterViewController *vc = [[MDPersonalCenterViewController alloc] init];
        vc.nav = self.navigationController;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
     
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(MDCustomBarHeight);
    }];
}


#pragma mark -- delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDHomeTableViewCell *cell = [_tableview dequeueReusableCellWithIdentifier:NSStringFromClass([MDHomeTableViewCell class])];
    [cell loadData:self.datasource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MDWriteNoteViewController *vc = [[MDWriteNoteViewController alloc] initWithModel:self.datasource[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除日记" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self.vm deleteModelWithOrderNum:self.datasource[indexPath.row].orderNum];
        [self.datasource removeObjectAtIndex:indexPath.row];
        completionHandler (YES);
        [self.tableview reloadData];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}


#pragma mark -- getter and setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        [_tableview registerClass:[MDHomeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MDHomeTableViewCell class])];
        
    }
    return _tableview;
}


@end
