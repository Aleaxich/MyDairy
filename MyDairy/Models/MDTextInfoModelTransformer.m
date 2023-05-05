//
//  MDTextInfoModelTransformer.m
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/28.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDTextInfoModelTransformer.h"
#import "MDTextInfoModel.h"
#import "MyDairy-Swift.h"


@implementation MDTextInfoModelTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [MDTextInfoModel class];
}

- (id)transformedValue:(id)value {
    return [NSKeyedArchiver archivedDataWithRootObject:value requiringSecureCoding:YES error:nil];
}

- (id)reverseTransformedValue:(id)value {
   return [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[MDTextInfoModel.class,NSString.class,NSMutableArray.class,NSData.class,NSArray.class]] fromData:value error:nil];
   
}
@end
