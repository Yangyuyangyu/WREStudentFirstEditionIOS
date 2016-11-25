//
//  ClassFrame.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ClassFrame.h"
#import "ClassS.h"

@implementation ClassFrame

- (void)setClassS:(ClassS *)classS{

    _classS = classS;
    [self setUpTextFrame];
    CGFloat toolBarY = CGRectGetMaxY(_classViewFrame);
    // 计算工具条
    CGFloat toolBarX = 0;
    CGFloat toolBarW = XN_WIDTH;
    CGFloat toolBarH = 35;
    _toolBarFrame = CGRectMake(toolBarX, toolBarY + 1, toolBarW, toolBarH);
    
    // 计算cell高度
    _cellHeight = CGRectGetMaxY(_toolBarFrame);
}

- (void)setUpTextFrame{
    // 正文
    CGFloat textX = CZStatusCellMargin;
    CGFloat textY = 0;
    
    CGFloat textW = XN_WIDTH - 2 * CZStatusCellMargin;
    CGSize textSize = [_classS.text sizeWithFont:CZTextFont constrainedToSize:CGSizeMake(textW, MAXFLOAT)];
    _textFrame = (CGRect){{textX,textY},textSize};
    
    CGFloat originH = CGRectGetMaxY(_textFrame) + CZStatusCellMargin;
    
    // 配图
    if (_classS.pic_urls.count) {
        CGFloat photosX = CZStatusCellMargin;
        CGFloat photosY = CGRectGetMaxY(_textFrame) + CZStatusCellMargin;
        CGSize photosSize = [self photosSizeWithCount:_classS.pic_urls.count];
        
        _photosFrame = (CGRect){{photosX,photosY},photosSize};
        originH = CGRectGetMaxY(_photosFrame) + CZStatusCellMargin;
    }
    
    // classViewframe
    CGFloat originX = 0;
    CGFloat originY = 10;
    CGFloat originW = XN_WIDTH;
    
    _classViewFrame = CGRectMake(originX, originY, originW, originH);
}

#pragma mark - 计算配图的尺寸
- (CGSize)photosSizeWithCount:(NSInteger)count
{
    // 获取总列数
    NSInteger cols = count == 4? 2 : 3;
    // 获取总行数 = (总个数 - 1) / 总列数 + 1
    NSInteger rols = (count - 1) / cols + 1;
    CGFloat photoWH = 70;
    CGFloat w = cols * photoWH + (cols - 1) * CZStatusCellMargin;
    CGFloat h = rols * photoWH + (rols - 1) * CZStatusCellMargin;
    
    
    return CGSizeMake(w, h);
    
}
@end
