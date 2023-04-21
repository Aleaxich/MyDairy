//
//  TestDownloadViewController.h
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/21.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestDownloadViewController : MDBaseViewController

- (BOOL)isFontDownloaded:(NSString *)fontName;

- (void)downloadWithFontName:(NSString *)fontName;

@end

NS_ASSUME_NONNULL_END
