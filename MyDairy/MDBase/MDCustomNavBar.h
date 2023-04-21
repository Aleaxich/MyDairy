//
//  MDCustomNavBar.h
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/30.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^buttonAction)(void);


@interface MDCustomNavBar : UIView


- (void)leftButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action;

- (void)centerButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action;

- (void)rightButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action;




@end

NS_ASSUME_NONNULL_END
