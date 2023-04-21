//
//  MDBaseFuncHelper.m
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/29.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDBaseFuncHelper.h"

@implementation MDBaseFuncHelper

+ (UIViewController *)mdGetCurrentShowViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self getCurrentShowViewController:rootVC];
}


+ (UIViewController *)getCurrentShowViewController:(UIViewController *)vc {
    UIViewController *resultVC;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getCurrentShowViewController:[(UINavigationController *)vc visibleViewController]];
    } else if ([self isKindOfClass:[UITabBarController class]]) {
        return [self getCurrentShowViewController:[(UITabBarController *)vc selectedViewController]];
    } else if ([vc presentedViewController]) {
        [self getCurrentShowViewController:[vc presentedViewController]];
    } else {
        resultVC = vc;
    }
    return resultVC;
}




@end
