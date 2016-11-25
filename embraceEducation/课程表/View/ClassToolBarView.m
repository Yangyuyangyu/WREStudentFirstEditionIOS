//
//  ClassToolBarView.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ClassToolBarView.h"
#import "ClassS.h"

@interface ClassToolBarView ()


@end

@implementation ClassToolBarView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 添加所有子控件
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self addSubview:self.view];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 20, 20)];
    }
    return _imageView;
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageView.frame) + 15, 8, 200, 21)];
        _label.font = [UIFont systemFontOfSize:14];
    }
    return _label;
}

- (UIView *)view{
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XN_WIDTH, 1)];
        _view.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
    }
    return _view;
}
@end
