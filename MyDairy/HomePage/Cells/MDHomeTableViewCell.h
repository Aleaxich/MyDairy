//
//  MDHomeTableViewCell.h
//  MyDairyAPP
//
//  Created by 匿名用户的笔记本 on 2023/3/13.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDDairyCommonModel;

NS_ASSUME_NONNULL_BEGIN

@interface MDHomeTableViewCell : UITableViewCell

- (void)loadData:(MDDairyCommonModel *)model;

@end

NS_ASSUME_NONNULL_END
