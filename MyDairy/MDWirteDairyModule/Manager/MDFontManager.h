//
//  MDFontManager.h
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/27.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef  void (^matchBlock)(void);

@interface MDFontManager : NSObject

@property (nonatomic,copy) matchBlock matchBlock;

- (void)matchFontSysFontWithName:(NSString *)fontName;

//@property(nonatomic,weak) UITextView *textview;

//- (void)downLoadWithFontName:(NSString *) name;
//
//- (BOOL)isFontDownloaded:(NSString *)fontName;

@end

NS_ASSUME_NONNULL_END
