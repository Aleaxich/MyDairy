//
//  UIViewController+MDCustomNavBar.m
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/30.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "UIViewController+MDCustomNavBar.h"
#import "MDCustomNavBar.h"
#import <objc/runtime.h>
#import "Masonry.h"

const CGFloat MDCustomBarHeight = 100;

@implementation UIViewController (MDCustomNavBar)

-(void)setMdNavBar:(MDCustomNavBar *)mdNavBar {
    objc_setAssociatedObject(self, @selector(mdNavBar), mdNavBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MDCustomNavBar *)mdNavBar {
    return objc_getAssociatedObject(self, @selector(mdNavBar));
}

- (void)setupCustomNavBar {
    MDCustomNavBar *navBar = [[MDCustomNavBar alloc] init];
    self.mdNavBar = navBar;
    [self.view addSubview:self.mdNavBar];
    [self.mdNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.mas_equalTo(self.view);
        make.height.mas_equalTo(MDCustomBarHeight);
    }];
}

- (void)setNavLeftButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action {
    NSAssert(self.mdNavBar != nil, @"先初始化 nav哦");
    [self.mdNavBar leftButtonTitle:title withImage:imgage withSelected:action];
}

- (void)setNavCenterButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action {
    NSAssert(self.mdNavBar != nil, @"先初始化 nav哦");
    [self.mdNavBar centerButtonTitle:title withImage:imgage withSelected:action];

}

- (void)setNavRightButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action {
    NSAssert(self.mdNavBar != nil, @"先初始化 nav哦");
    [self.mdNavBar rightButtonTitle:title withImage:imgage withSelected:action];
}

@end
