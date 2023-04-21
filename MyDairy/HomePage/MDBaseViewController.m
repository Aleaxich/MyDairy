//
//  MDBaseViewController.m
//  MyDairyAPP
//
//  Created by 匿名用户的笔记本 on 2023/3/13.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDBaseViewController.h"
#import "UIViewController+MDCustomNavBar.h"


@interface MDBaseViewController ()

@end

@implementation MDBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}



@end
