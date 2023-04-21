//
//  MDDairyCommonModel+CoreDataProperties.h
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/28.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//
//

#import "MDDairyCommonModel+CoreDataClass.h"
@import UIKit;


NS_ASSUME_NONNULL_BEGIN

@interface MDDairyCommonModel (CoreDataProperties)

+ (NSFetchRequest<MDDairyCommonModel *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

/// 是否是草稿
@property (nonatomic) BOOL draft;
/// 是否是之前已经写完的数据
@property (nonatomic) BOOL finished;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *mood;
@property (nonatomic) int32_t orderNum;
@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, copy) NSString *weather;
@property (nullable, nonatomic, retain) MDTextInfoModel *textInfo;
/// 日记创建日期
@property (nullable, nonatomic, copy) NSDate *createdDate;


@end

NS_ASSUME_NONNULL_END
