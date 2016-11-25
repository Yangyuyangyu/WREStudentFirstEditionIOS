//
//  CZPopMenu.m
//  传智微博
//
//  Created by apple on 15-3-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZPopMenu.h"



@implementation CZPopMenu

// 显示弹出菜单
+ (instancetype)showInRect:(CGRect)rect
{
    CZPopMenu *menu = [[CZPopMenu alloc] initWithFrame:rect];
    menu.userInteractionEnabled = YES;
//    menu.image = [UIImage imageWithStretchableName:@"popover_background"];
//    menu.backgroundColor = [UIColor redColor];
//    [CZKeyWindow addSubview:menu];
    
    return menu;
}

// 隐藏弹出菜单
+ (void)hide
{
    for (UIView *popMenu in CZKeyWindow.subviews) {
        if ([popMenu isKindOfClass:self]) {
            [popMenu removeFromSuperview];
        }
    }
}

// 设置内容视图
- (void)setContentView:(UIView *)contentView
{
    // 先移除之前内容视图
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    contentView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:contentView];
   
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算内容视图尺寸
    CGFloat popW = XN_WIDTH - 20;
    CGFloat popH = XN_HEIGHT/3;
    _contentView.frame = CGRectMake(0, 0, popW, popH);
    
}

@end
