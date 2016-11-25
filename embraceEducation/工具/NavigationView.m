//
//  NavigationView.m
//  
//
//  Created by afaga on 14/12/24.
//  Copyright © 2014年 肖恩. All rights reserved.
//

#import "NavigationView.h"

@interface NavigationView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) UIImage * rightButtonImage;
@property (nonatomic, strong) UIImage * leftButtonImage;
@end

@implementation NavigationView

- (instancetype)initWithTitle:(NSString *)title leftButtonImage:(UIImage *)leftButtonImage
{
    return [self initWithTitle:title leftButtonImage:leftButtonImage rightButtonImage:nil];
}


- (instancetype)initWithTitle:(NSString *)title leftButtonImage:(UIImage *)leftButtonImage rightButtonImage:(UIImage *)rightButtonImage

{
    self = [super initWithFrame:CGRectMake(0, 0, XN_WIDTH, 64)];
    if (self) {
        self.title = title;
        self.leftButtonImage = leftButtonImage;
        self.rightButtonImage = rightButtonImage;
        [self initializeApperance];
    }
    return self;
}

- (void)initializeApperance
{
    self.backgroundColor = XN_COLOR_GREEN_MINT;
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftButton];
    if (self.rightButtonImage) {
        [self addSubview:self.rightButton];
    }
}

- (void)onLeftButton
{
    if (self.leftButtonAction) {
        self.leftButtonAction();
    }
}

- (void)onRightButton
{
    if (self.rightButtonAction) {
        self.rightButtonAction();
    }
}

#pragma mark - getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.title;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleLabel sizeToFit];
        _titleLabel.center = CGPointMake(XN_WIDTH/2, 45);
    }
    return _titleLabel;
}

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 60, 50);
        _leftButton.center = CGPointMake(20, 40);
        
        [_leftButton addTarget:self action:@selector(onLeftButton) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setImage:self.leftButtonImage forState:UIControlStateNormal];
        
        
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(0, 0, 60, 50);
        _rightButton.center = CGPointMake(CGRectGetMaxX(self.bounds) - 20, 40);
        
        [_rightButton addTarget:self action:@selector(onRightButton) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setImage:self.rightButtonImage forState:UIControlStateNormal];
        
        
    }
    return _rightButton;
}


@end
