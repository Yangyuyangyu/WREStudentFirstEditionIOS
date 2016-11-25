//
//  MySelf.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/9.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySelf : NSObject
/*!
 *  @brief 学生个人信息
 */
- (void)studentInfoList:(NSString *)studentId;
/*!
 *  @brief 修改个人信息
 */
- (void)editInfokInfoList:(NSString *)uid head_img:(NSString *)head_img name:(NSString *)name sex:(NSString *)sex birthday:(NSString *)birthday home:(NSString *)home;
/*!
 *  @brief 关于我们
 */
- (void)aboutUsInfoList;
/*!
 *  @brief 消息中心
 */
- (void)messageInfoList;
/*!
 *  @brief 修改密码
 */
- (void)editPwdInfokInfoList:(NSString *)student oldPass:(NSString *)oldPass newPass:(NSString *)newPass;
/*!
 *  @brief 意见反馈
 */
- (void)feedbackInfokInfoList:(NSString *)student content:(NSString *)content email:(NSString *)email;
/*!
 *  @brief 短信邀请好友
 */
- (void)inviteInfoList:(NSString *)mobile;

/*!
 *  @brief 图片上传接口
 */
- (void)imgUploadInfokInfoList:(NSData *)name;
/*!
 *  @brief 创建百度推送标签
 */
- (void)createTagInfokInfoList:(NSString *)uid channelId:(NSString *)channelId;
/*!
 *  @brief 推送消息
 */
- (void)pushMessageInfoList:(NSString *)uid;
@end
