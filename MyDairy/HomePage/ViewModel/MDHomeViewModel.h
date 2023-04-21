//
//  MDHomeViewModel.h
//  MyDairyAPP
//
//  Created by 匿名用户的笔记本 on 2023/3/13.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MDDairyCommonModel;

NS_ASSUME_NONNULL_BEGIN

@interface MDHomeViewModel : NSObject

/// 当前日期的数据
@property (nonatomic,strong) MDDairyCommonModel *currentDateModel;

/// 获取本地文件
-(NSMutableArray<MDDairyCommonModel *> *)getLocalFile;

/// 删除数据
- (void)deleteModelWithOrderNum:(int32_t)orderNum;


@end

NS_ASSUME_NONNULL_END
