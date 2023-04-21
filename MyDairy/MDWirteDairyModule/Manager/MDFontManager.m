//
//  MDFontManager.m
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/27.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDFontManager.h"
#import <CoreText/CoreText.h>
@import UIKit;


@interface MDFontManager() {
    UILabel  *_label;
    NSString *_errorMessage;
    NSString *_postName;
    
}



@end

@implementation MDFontManager

- (void)matchFontSysFontWithName:(NSString *)fontName {
    
    UIFont *aFont = [UIFont fontWithName:fontName size:12.];
    //判断字体是否已经被下载
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame ||
                  [aFont.familyName compare:fontName] == NSOrderedSame)) {
        NSLog(@"字体已经被下载");
        return;
    }
    //用字体的PostScript名字创建一个Dictionary
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // 创建一个字体描述对象CTFontDescriptorRef
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    //将字体描述对象放到一个NSMutableArray中
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    //匹配字体
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)descs, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef  _Nonnull progressParameter) {
        
        if (state == kCTFontDescriptorMatchingDidBegin) {//字体已经匹配
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"字体开始匹配");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            if (!errorDuringDownload) {
                dispatch_async( dispatch_get_main_queue(), ^ {
                    NSLog(@"字体下载成功");
                    if (self.matchBlock) {
                        self.matchBlock();
                    }
                    return ;
                });
            }
        }
        return (BOOL)YES;
    });
}


@end
