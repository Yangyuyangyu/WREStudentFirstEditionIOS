//
//  CZPhotosView.m
//  传智微博
//
//  Created by apple on 15-3-12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZPhotosView.h"
#import "CZPhoto.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "CZPhotoView.h"

@implementation CZPhotosView
//1
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
        
        // 添加9个子控件
        NSLog(@"%@",_pic_urls);
        [self setUpAllChildView];

    }
    return self;
}


// 2添加9个子控件
- (void)setUpAllChildView
{
    for (int i = 0; i < 9; i++) {

        CZPhotoView *imageV = [[CZPhotoView alloc] init];
       
        imageV.tag = i;
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageV addGestureRecognizer:tap];
        
        [self addSubview:imageV];
    }
}

#pragma mark - 点击图片的时候调用
- (void)tap:(UITapGestureRecognizer *)tap
{
     UIImageView *tapView = tap.view;
    // CZPhoto -> MJPhoto
    int i = 0;
    NSMutableArray *arrM = [NSMutableArray array];
    for (CZPhoto *photo in _pic_urls) {
        MJPhoto *p = [[MJPhoto alloc] init];
        NSString *urlStr = photo.pic.absoluteString;
//        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"192.168.10.143" withString:@"192.168.10.138"];
        p.url = [NSURL URLWithString:urlStr];
        p.index = i;
        p.srcImageView = tapView;
        [arrM addObject:p];
        i++;
    }
    
   
    // 弹出图片浏览器
    // 创建浏览器对象
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    // MJPhoto
    brower.photos = arrM;
    brower.currentPhotoIndex = tapView.tag;
    [brower show];
}
//3
- (void)setPic_urls:(NSArray *)pic_urls
{
    // 4
    _pic_urls = pic_urls;
    NSLog(@"%@",_pic_urls);
    int count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        
        CZPhotoView *imageV = self.subviews[i];
        
        if (i < _pic_urls.count) { // 显示
            imageV.hidden = NO;

            // 获取CZPhoto模型
            CZPhoto *photo = _pic_urls[i];
            
            imageV.photo = photo;
           
            
        }else{
            imageV.hidden = YES;
        }
        
    }
    
}

// 计算尺寸
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 70;
    CGFloat h = 70;
    CGFloat margin = 10;
    int col = 0;
    int rol = 0;
    int cols = _pic_urls.count==4?2:3;
    // 计算显示出来的imageView
    for (int i = 0; i < _pic_urls.count; i++) {
        col = i % cols;
        rol = i / cols;
        UIImageView *imageV = self.subviews[i];
        x = col * (w + margin);
        y = rol * (h + margin);
        imageV.frame = CGRectMake(x, y, w, h);
    }
    
    
}
@end
