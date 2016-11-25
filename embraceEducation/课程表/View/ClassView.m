//
//  ClassView.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ClassView.h"

#import "ClassFrame.h"
#import "ClassS.h"

#import "CZPhotosView.h"
#import <UIImageView+WebCache.h>

@interface ClassView ()
// 正文
@property (nonatomic, weak) UILabel *textView;

// 配图
@property (nonatomic, weak) CZPhotosView *photosView;

@end
@implementation ClassView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 添加所有子控件
        [self setUpAllChildView];
        self.userInteractionEnabled = YES;
//        self.image = [UIImage :@"timeline_card_top_background"];
    }
    return self;
}

- (void)setUpAllChildView{
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.font = CZTextFont;
    textView.numberOfLines = 0;
    [self addSubview:textView];
    _textView = textView;
    
    // 配图
    CZPhotosView *photosView = [[CZPhotosView alloc] init];
    [self addSubview:photosView];
    _photosView = photosView;
}

- (void)setClassF:(ClassFrame *)classF{
    _classF = classF;
    // 设置frame
    [self setUpFrame];
    // 设置data
    [self setUpData];

}

- (void)setUpFrame{
    // 正文
    _textView.frame = _classF.textFrame;
    
    // 配图
    _photosView.frame = _classF.photosFrame;
}

- (void)setUpData{
    ClassS *classS = _classF.classS;
    _textView.text = classS.text;
    _photosView.pic_urls = classS.pic_urls;
    NSLog(@"%@",classS.pic_urls);
}
@end
