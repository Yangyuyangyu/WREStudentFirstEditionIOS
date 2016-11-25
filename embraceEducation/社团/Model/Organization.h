//
//  Organization.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/6.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Organization : NSObject
/*!
 *  @brief 已加入的社团
 *
 *  @param uid  当前学生id
 *  @param page 当前页树
 */
- (void)myGroupInfoList:(NSString *)uid page:(NSString *)page;
/*!
 *  @brief 搜索社团
 *
 *  @param type 类型，按条件搜索时传入此参数，获取推荐数据传0
 *  @param name 名称，按条件搜索时传入此参数
 */
- (void)groupInfoList:(NSString *)type name:(NSString *)name;
- (void)groupInfoList1:(NSString *)type;
/*!
 *  @brief 申请加入社团
 *
 *  @param groupId   社团id
 *  @param studentId 学生id
 */
- (void)joinGroupInfoList:(NSString *)groupId studentId:(NSString *)studentId subjectId:(NSString *)subjectId;
/*!
 *  @brief 机构详情
 *
 *  @param agencyId 机构id
 */
- (void)agencyDetailInfoList:(NSString *)agencyId;
/*!
 *  @brief 社团详情
 *
 *  @param groupId   社团id
 *  @param studentId 学生id
 */
- (void)groupDetailInfoList:(NSString *)groupId studentId:(NSString *)studentId;
/*!
 *  @brief 社团动态详情
 *
 *  @param newsId 动态id
 */
- (void)newsDetailInfoList:(NSString *)newsId;
/*!
 *  @brief 社团管理制度
 *
 *  @param groupId 社团id
 */
- (void)ruleInfoList:(NSString *)groupId;
/*!
 *  @brief 社团建设
 */
- (void)groupBuildInfoList:(NSString *)groupId;
@end
