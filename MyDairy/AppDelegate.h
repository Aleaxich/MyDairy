//
//  AppDelegate.h
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/13.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

