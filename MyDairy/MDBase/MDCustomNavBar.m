//
//  MDCustomNavBar.m
//  MyDairy
//
//  Created by 匿名用户的笔记本 on 2023/3/30.
//  Copyright © 2023 匿名用户的笔记本. All rights reserved.
//

#import "MDCustomNavBar.h"
#import "Masonry.h"

@interface MDCustomNavBar()

@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *centerButton;



@property (nonatomic,copy) buttonAction leftAction;
@property (nonatomic,copy) buttonAction centerAction;
@property (nonatomic,copy) buttonAction rightAction;

@property (nonatomic,strong) UIView *crossLine;


@end


@implementation MDCustomNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubviews];
    }
    return self;
}

- (void)buildSubviews{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.mas_equalTo(self).mas_offset(30);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self addSubview:self.centerButton];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.bottom.mas_equalTo(-5);
        make.centerX.mas_equalTo(self);
         }];
    
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.size.mas_equalTo(CGSizeMake(35, 35));
        make.bottom.mas_equalTo(-5);
          make.right.mas_equalTo(self).mas_offset(-20);
      }];
    
    self.crossLine = [[UIView alloc] init];
    self.crossLine.backgroundColor = [UIColor grayColor];
    [self addSubview:self.crossLine];
    [self.crossLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(self);
    }];
}


- (void)leftButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action {
    self.leftButton.hidden = NO;
    [self.leftButton setTitle:title forState:UIControlStateNormal];
    [self.leftButton setBackgroundImage:imgage forState:UIControlStateNormal];
    self.leftAction = action;
}

- (void)centerButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action {
    self.centerButton.hidden = NO;
    [self.centerButton setTitle:title forState:UIControlStateNormal];
    [self.centerButton setBackgroundImage:imgage forState:UIControlStateNormal];
    self.centerAction = action;
}

- (void)rightButtonTitle:(NSString *)title withImage:(UIImage *)imgage withSelected:(buttonAction) action {
    self.rightButton.hidden = NO;
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:imgage forState:UIControlStateNormal];
    self.rightAction = action;
}

- (void)leftButtonAction {
    if (self.leftAction) {
        self.leftAction();
    }
}

- (void)rightButtonAction {
    if (self.rightAction) {
        self.rightAction();
    }
}

- (void)centerButtonAction {
    if (self.centerAction) {
        self.centerAction();
    }
}

-(UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.hidden = YES;
        [_leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.layer.cornerRadius = 12;
        _leftButton.layer.masksToBounds = YES;
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.hidden = YES;
        [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIButton *)centerButton {
    if (!_centerButton) {
        _centerButton = [[UIButton alloc] init];
        _centerButton.hidden = YES;
        [_centerButton addTarget:self action:@selector(centerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerButton;
}


@end
