//
//  Register.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/6.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Register : NSObject
/*!
 *  @brief 获取验证码
 */
- (void)sendCodeInfoList:(NSString *)mobile;
/*!
 *  @brief 注册
 */
- (void)registerInfoList:(NSString *)mobile pass:(NSString *)pass code:(NSString *)code log_id:(NSString *)log_id;
/*!
 *  @brief 登录
 */
- (void)loginInfoList:(NSString *)mobile pass:(NSString *)pass;
/*!
 *  @brief 忘记密码
 */
- (void)findPwdfoList:(NSString *)mobile code:(NSString *)code pass:(NSString *)pass log_id:(NSString *)log_id;
@end
