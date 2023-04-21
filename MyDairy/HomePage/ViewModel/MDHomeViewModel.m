//
//  MDHomeViewModel.m
//  MyDairyAPP
//
//  Created by 匿名用户的笔记本 on 2023/3/13.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDHomeViewModel.h"
#import "MDDairyCommonModel+CoreDataClass.h"
#import "MyDairy-Swift.h"


@interface  MDHomeViewModel()

@property (nonatomic,strong) MDCoreDataManager *manager;
@property (nonatomic,strong) NSMutableArray<MDDairyCommonModel *> *modelArray;

@end


@implementation MDHomeViewModel


- (instancetype)init {
    if (self == [super init]) {
        self.manager = MDCoreDataManager.shareInstance;
        _modelArray = @[].mutableCopy;
    }
    return self;
}

- (NSMutableArray<MDDairyCommonModel *> *)getLocalFile {
    self.modelArray = [self.manager getCoreData].mutableCopy;
    return self.modelArray;
}

- (MDDairyCommonModel *)currentDateModel {
    for (MDDairyCommonModel *model in self.modelArray) {
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)model.orderNum];
        if ([self checkToday:date]) {
            return model;
        }
    }
    return nil;
}

/// 判断是不是当天
- (BOOL)checkToday:(NSDate *)date {
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today day] == [otherDay day] && [today month] == [otherDay month] && [today year] == [otherDay year] && [today era] == [otherDay era]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)deleteModelWithOrderNum:(int32_t)orderNum {
    [self.manager deleteWithOrderNum:orderNum];
}

@end
