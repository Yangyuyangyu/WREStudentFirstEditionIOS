//
//  CZCover.m
//  微博
//
//  Created by apple on 15-3-5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZCover.h"

@implementation CZCover

// 设置浅灰色蒙板
- (void)setDimBackground:(BOOL)dimBackground
{
    _dimBackground = dimBackground;
    
    if (dimBackground) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
    }else{
        self.alpha = 1;
        self.backgroundColor = [UIColor clearColor];
    }
}
// 显示蒙板
+ (instancetype)show
{
    CZCover *cover = [[CZCover alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor colorWithWhite:0.667 alpha:0.296];
    
//    [self addSubview:cover];
    
    return cover;
  
}

- (void)remove{
    // 移除蒙板
    [self removeFromSuperview];
    
    // 通知代理移除菜单
    if ([_delegate respondsToSelector:@selector(coverDidClickCover:)]) {
        
        [_delegate coverDidClickCover:self];
        
    }
}

// 点击蒙板的时候做事情
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self remove];
}

@end
