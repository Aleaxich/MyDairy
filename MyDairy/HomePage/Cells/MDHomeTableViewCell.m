//
//  MDHomeTableViewCell.m
//  MyDairyAPP
//
//  Created by 匿名用户的笔记本 on 2023/3/13.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDHomeTableViewCell.h"
#import "Masonry.h"
#import "MDDairyCommonModel+CoreDataClass.h"
#import "UIColor+MDColorHelper.h"
#import "MDTextInfoModel.h"



@interface MDHomeTableViewCell()
/// 文字
@property (nonatomic,strong) UILabel *label;
///封面
@property (nonatomic,strong) UIImageView *pic;
///日期
@property (nonnull,strong) UILabel *dateLabel;

///分割线
@property (nonnull,strong) UIView *crossLine;

@end

@implementation MDHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildSubviews];
    }
    return self;
}

- (void)loadData:(MDDairyCommonModel *)model {
    self.label.text = model.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd";
    self.dateLabel.text = [formatter stringFromDate:model.createdDate];
    if (model.textInfo.imageList.count != 0) {
        self.pic.image = [UIImage imageWithData:model.textInfo.imageList[0]];
    } else {
        self.pic.image = nil;
    }
}

- (void)buildSubviews {
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
    self.crossLine = [[UIView alloc] init];
    self.crossLine.backgroundColor = [UIColor colorWithHexString:@"D3D3D3"];
    [self.contentView addSubview:self.crossLine];
    [self.crossLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 25));
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.dateLabel.mas_right).offset(5);
    }];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor blackColor];
    self.label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.label.font = [UIFont fontWithName:@"MLingWaiMedium-SC" size:14];
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.crossLine).mas_offset(5);
        make.top.mas_equalTo(self).mas_offset(25);
        make.width.mas_equalTo(200);
    }];
    
    self.pic = [[UIImageView alloc] init];
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    self.pic.layer.cornerRadius = 8;
    self.pic.layer.masksToBounds = YES;
    [self.contentView addSubview:self.pic];
    [self.pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 55));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).mas_offset(-10);
    }];
    
}

@end
