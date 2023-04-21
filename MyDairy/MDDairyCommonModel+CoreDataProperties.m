//
//  MDDairyCommonModel+CoreDataProperties.m
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/28.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//
//

#import "MDDairyCommonModel+CoreDataProperties.h"
#import "MDTextInfoModel.h"

@implementation MDDairyCommonModel (CoreDataProperties)


+ (NSFetchRequest<MDDairyCommonModel *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MDDairyCommonModel"];
}

@dynamic draft;
@dynamic finished;
@dynamic image;
@dynamic mood;
@dynamic orderNum;
@dynamic text;
@dynamic weather;
@dynamic textInfo;
@dynamic createdDate;

@end
