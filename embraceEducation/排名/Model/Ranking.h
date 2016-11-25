//
//  Ranking.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/9.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ranking : NSObject
/*!
 *  @brief 成绩排名
 */
- (void)scoreInfoList:(NSString *)courseId studentId:(NSString *)studentId;
/*!
 *  @brief 成绩详情
 */
- (void)myScoreInfoList:(NSString *)courseId studentId:(NSString *)studentId;
/*!
 *  @brief 社团排名
 */
- (void)rankInfoList;
/*!
 *  @brief 某个社团的排名信息
 */
- (void)groupRankInfoList:(NSString *)groupId;

@end
