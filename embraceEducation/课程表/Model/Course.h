//
//  Course.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/9.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject
/*!
 *  @brief 课程规划
 */
- (void)coursePlanInfoList:(NSString *)groupId;
/*!
 *  @brief 点击申请换班时查询已加入的科目
 */
- (void)mySubjectInfoList:(NSString *)groupId sid:(NSString *)sid;
/*!
 *  @brief 换班时查询可选择的社团
 */
- (void)allGroupInfoList:(NSString *)groupId;
/*!
 *  @brief 换班时选择社团后查询科目
 */
- (void)getSubjectInfoList:(NSString *)groupId;
/*!
 *  @brief 提交换班申请
 *
 *  @param groupId   社团id
 *  @param student   当前学生id
 *  @param subjectId 科目id
 *  @param reason    原因
 *  @param from      原科目id
 */
- (void)changeClassInfoList:(NSString *)groupId student:(NSString *)student subjectId:(NSString *)subjectId reason:(NSString *)reason from:(NSString *)from;
/*!
 *  @brief 课程表
 */
- (void)courseListInfoList:(NSString *)uid week:(NSString *)week;
/*!
 *  @brief 确认上课
 *
 *  @param Id  上课记录id（课程表接口course下id的值）
 *  @param sid 学生id
 */
- (void)confirmInfoList:(NSString *)Id sid:(NSString *)sid;
/*!
 *  @brief 提交评价课程
 *
 *  @param Id        上课记录id
 *  @param studentId 学生id
 *  @param content   评价内容
 */
- (void)commentInfoList:(NSString *)Id studentId:(NSString *)studentId content:(NSString *)content;
/*!
 *  @brief 课程详情
 *
 *  @param courseId 课程id
 *  @param Id 课程记录id
 */
- (void)courseInfoInfoList:(NSString *)courseId Id:(NSString *)Id;
/*!
 *  @brief 请假
 *
 *  @param student  学生id
 *  @param courseId 课程id
 *  @param type     请假类型
 *  @param start    开始时间
 *  @param end      结束时间
 *  @param reason   备注
 */
- (void)leaveInfoList:(NSString *)student courseId:(NSString *)courseId type:(NSString *)type start:(NSString *)start end:(NSString *)end reason:(NSString *)reason;
/*!
 *  @brief 投诉时查询老师信息
 */
- (void)teacherInfoList:(NSString *)teacherId;
/*!
 *  @brief 保存投诉
 *
 *  @param student   学生id
 *  @param teacherId 老师id
 *  @param reason    原因
 */
- (void)complaintInfoList:(NSString *)student teacherId:(NSString *)teacherId reason:(NSString *)reason;
/*!
 *  @brief 预约小课
 *
 *  @param courseId  课程id
 *  @param studentId 学生id
 *  @param time      上课时间
 *  @param place     上课地点
 */
- (void)appointInfoList:(NSString *)courseId studentId:(NSString *)studentId time:(NSString *)time place:(NSString *)place;
/*!
 *  @brief 查看课程报告
 */
- (void)courseReportInfoList:(NSString *)courseId studentId:(NSString *)studentId;
/*!
 *  @brief 提交作业
 *
 *  @param student 学生id
 *  @param course  课程id
 *  @param time    练习时长
 *  @param finish  是否完成
 *  @param remark  备注
 */
- (void)homeworkInfoList:(NSString *)student course:(NSString *)course time:(NSString *)time finish:(NSString *)finish remark:(NSString *)remark;
/*!
 *  @brief 历史课程
 */
- (void)finishedClassInfoList;
/*!
 *  @brief 社团对应的上课记录
 *
 *  @param groupId 社团id
 *  @param page    页数
 */
- (void)groupClassInfoList:(NSString *)groupId page:(NSString *)page;
@end
