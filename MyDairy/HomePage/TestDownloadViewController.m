//
//  TestDownloadViewController.m
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/21.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "TestDownloadViewController.h"
#import <CoreText/CoreText.h>

@interface TestDownloadViewController ()
{
    UILabel  *_label;
    NSString *_errorMessage;
    NSString *_postName;
}

@end

@implementation TestDownloadViewController

- (instancetype)init {
    if (self = [super init]) {
//        _postName = @"DFWaWaSC-W5";
        _postName = @"STKaiti";
        
        BOOL isDownload = [self isFontDownloaded:_postName];
        if (isDownload) {
            _label.font = [UIFont fontWithName:_postName size:12];
            [_label sizeToFit];
        }else{
            [self downloadWithFontName:_postName];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    _label.numberOfLines = 0;
    _label.text = @"我是字体，我是字体，我是字体";
    _label.textColor = [UIColor redColor];
    _label.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:_label];
    
    //娃娃体
    _postName = @"DFWaWaSC-W5";
    
    BOOL isDownload = [self isFontDownloaded:_postName];
    if (isDownload) {
        _label.font = [UIFont fontWithName:_postName size:12];
        [_label sizeToFit];
    }else{
        [self downloadWithFontName:_postName];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

//判断字体是否已经被下载
- (BOOL)isFontDownloaded:(NSString *)fontName{
    UIFont *aFont = [UIFont fontWithName:fontName size:12.];
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isFontDownloaded:(NSString *)fontName{
    UIFont *aFont = [UIFont fontWithName:fontName size:12.];
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    }else{
        return NO;
    }
}

//下载字体
- (void)downloadWithFontName:(NSString *)fontName{
    //用字体的PostScript名字创建一个 dictionary
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName,kCTFontNameAttribute, nil];
    //创建一个字体描述对象 CTFontDescriptorRef
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    //将字体描述对象放到一个NSMutableArray中
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id _Nonnull)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;

    //下载字体
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)descs , NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef  _Nonnull progressParameter) {
         double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        switch (state) {
            case kCTFontDescriptorMatchingDidBegin:
                //字体已经匹配
                
                break;
            case kCTFontDescriptorMatchingWillBeginDownloading:
                //字体开始下载
                NSLog(@"字体%@ 开始下载",fontName);

                break;
            case kCTFontDescriptorMatchingDownloading:
                
                NSLog(@" 下载进度 %.0f",progressValue);
                
                break;
            case kCTFontDescriptorMatchingDidFinishDownloading:
                //字体下载完成
                
                break;
            case kCTFontDescriptorMatchingDidFinish:
            {
                //字体已经下载完成
                if (!errorDuringDownload) {
                    NSLog(@"字体%@ 已经下载完成",fontName);
                    dispatch_async( dispatch_get_main_queue(), ^ {
                        // 可以在这里修改 UI 控件的字体
                        _label.font = [UIFont fontWithName:_postName size:14];
                        _label.textColor = UIColor.whiteColor;
                        return ;
                    });
                }
    
            }
                break;
            case kCTFontDescriptorMatchingDidFailWithError:
                //下载错误
            {
                NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
                if (error != nil) {
                    _errorMessage = [error description];
                } else {
                    _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
                }
                // 设置标志
                errorDuringDownload = YES;
                NSLog(@" 下载错误: %@", _errorMessage);
            }
                break;
                
            default:
                break;
        }
        return YES;
    });
}




@end
