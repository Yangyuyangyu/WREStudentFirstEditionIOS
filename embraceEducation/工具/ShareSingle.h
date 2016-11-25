//
//  ShareSingle.h
//  BanDouApp
//
//  Created by waycubeIOSb on 16/3/27.
//  Copyright © 2016年 waycubeOXA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareSingle : NSObject
@property (nonatomic, copy)NSString *head;//头像
@property (nonatomic, copy)NSString *name;//昵称
@property (nonatomic, copy)NSString *sex;//性别
@property (nonatomic, copy)NSString *birthday;//生日
@property (nonatomic, copy)NSString *addr;//家庭住址
@property (nonatomic, copy)NSString *email;//邮箱
@property (nonatomic, copy)NSString *phone;//电话
@property (nonatomic, copy)NSString *password;//密码
@property (nonatomic, copy)NSString *num;//消息条数
@property (nonatomic, copy)NSString *customerService;
+ (ShareSingle *)shareInstance;
@end
