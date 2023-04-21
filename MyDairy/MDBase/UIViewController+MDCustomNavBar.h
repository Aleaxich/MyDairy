//
//  UIViewController+MDCustomNavBar.h
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/30.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDCustomNavBar;

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat MDCustomBarHeight;

typedef void(^buttonAction)(void);

@interface UIViewController (MDCustomNavBar)

/// 初始化 nav
- (void)setupCustomNavBar;

- (void)setNavLeftButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action;

- (void)setNavCenterButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action;

- (void)setNavRightButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action;

@property(nonatomic,strong) MDCustomNavBar *mdNavBar;



@end

NS_ASSUME_NONNULL_END
