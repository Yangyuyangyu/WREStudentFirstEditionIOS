//
//  ShareSingle.m
//  BanDouApp
//
//  Created by waycubeIOSb on 16/3/27.
//  Copyright © 2016年 waycubeOXA. All rights reserved.
//

#import "ShareSingle.h"

@implementation ShareSingle
// GCD 创建单例
+ (ShareSingle *)shareInstance{
    static ShareSingle *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ShareSingle alloc] init];
    });
    return share;
}
@end
