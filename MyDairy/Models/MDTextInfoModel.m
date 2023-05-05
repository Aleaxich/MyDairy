////
////  MDTextInfoModel.m
////  MyDairy
////
////  Created by 匿名用户的笔记本 on 2023/3/28.
////  Copyright © 2023 匿名用户的笔记本. All rights reserved.
////
//
//#import "MDTextInfoModel.h"
//
//@implementation MDTextInfoModel
//
//+ (BOOL)supportsSecureCoding {
//    return YES;
//}
//
//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    [coder encodeObject:self.mdTextColorHexString forKey:@"mdTextColorHexString"];
//    [coder encodeInteger:self.mdTextAligment forKey:@"mdTextAligment"];
//    [coder encodeObject:self.mdFontName forKey:@"mdFontName"];
//    [coder encodeInteger:self.mdFontSize forKey:@"mdFontSize"];
//    [coder encodeDouble:self.mdFontWeight forKey:@"mdFontWeight"];
//    [coder encodeObject:self.imageList forKey:@"mdImageList"];
//}
//
//
//- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
//    if (self = [super init]) {
//        self.mdTextColorHexString =  [coder decodeObjectForKey:@"mdTextColorHexString"];
//        self.mdTextAligment = (NSTextAlignment)[coder decodeIntegerForKey:@"mdTextAligment"];
//        self.mdFontName = [coder decodeObjectForKey:@"mdFontName"];
//        self.mdFontSize = [coder decodeIntegerForKey:@"mdFontSize"];
//        self.mdFontWeight = (UIFontWidth)[coder decodeDoubleForKey:@"mdFontWeight"];
//        self.imageList = [coder decodeObjectForKey:@"mdImageList"];
//    }
//    return self;
//}
//
//@end
