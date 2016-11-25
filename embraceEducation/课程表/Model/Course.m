//
//  Course.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/9.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "Course.h"
#import "NetworkingManager.h"


@implementation Course

- (void)coursePlanInfoList:(NSString *)groupId {
//    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/coursePlan?groupId=%@",Basicurl,groupId];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"课程规划成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"coursePlanInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"课程规划失败%@",object);
    }];
}

- (void)mySubjectInfoList:(NSString *)groupId sid:(NSString *)sid{
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/mySubject?groupId=%@&sid=%@",Basicurl,groupId,sid];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"点击申请换班时查询已加入的科目成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mySubjectInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"点击申请换班时查询已加入的科目失败%@",object);
    }];
}

- (void)allGroupInfoList:(NSString *)groupId {
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/allGroup?groupId=%@",Basicurl,groupId];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"换班时查询可选择的社团成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allGroupInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"换班时查询可选择的社团失败%@",object);
    }];
}

- (void)getSubjectInfoList:(NSString *)groupId {
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/getSubject?groupId=%@",Basicurl,groupId];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"换班时选择社团后查询科目成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getSubjectInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"换班时选择社团后查询科目失败%@",object);
    }];
}

- (void)changeClassInfoList:(NSString *)groupId student:(NSString *)student subjectId:(NSString *)subjectId reason:(NSString *)reason from:(NSString *)from{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/changeClass",Basicurl];
    NSDictionary *dic = @{@"groupId":groupId,@"student":student,@"subjectId":subjectId,@"reason":reason,@"from":from};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"提交换班申请成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeClassInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"提交换班申请失败%@",object);
    }];
}

- (void)courseListInfoList:(NSString *)uid week:(NSString *)week{
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/courseList?id=%@&week=%@",Basicurl,uid,week];
    NSLog(@"课程表%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"课程表成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"courseListInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"课程表失败%@",object);
    }];
}

- (void)confirmInfoList:(NSString *)Id sid:(NSString *)sid {
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/confirm",Basicurl];
    NSDictionary *dic = @{@"id":Id,@"sid":sid};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"确认上课成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"确认上课失败%@",object);
    }];
}

- (void)commentInfoList:(NSString *)Id studentId:(NSString *)studentId content:(NSString *)content{
    NSString *encoded = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/comment",Basicurl];
    NSDictionary *dic = @{@"id":Id,@"studentId":studentId,@"content":encoded};
    NSLog(@"%@",dic);
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"提交评价课程成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"commentInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"提交评价课程失败%@",object);
    }];
}


- (void)courseInfoInfoList:(NSString *)courseId Id:(NSString *)Id{
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/courseInfo?courseId=%@&studentId=%@&id=%@",Basicurl,courseId,uid,Id];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSDictionary *dic = [self deleteAllNullValue:object];
        NSLog(@"课程详情成功%@",dic);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"courseInfoInfoList" object:nil userInfo:dic];
    } failureBlock:^(id object) {
        NSLog(@"课程详情失败%@",object);
    }];
}

- (void)leaveInfoList:(NSString *)student courseId:(NSString *)courseId type:(NSString *)type start:(NSString *)start end:(NSString *)end reason:(NSString *)reason{
    NSString *reason_ = [reason stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/leave",Basicurl];
    NSDictionary *dic = @{@"student":student,@"courseId":courseId,@"type":type,@"start":start,@"end":end,@"reason":reason_};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"请假成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"请假失败%@",object);
    }];
}

- (void)teacherInfoList:(NSString *)teacherId {
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/teacherInfo?teacherId=%@",Basicurl,teacherId];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"投诉时查询老师信息成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"teacherInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"投诉时查询老师信息失败%@",object);
    }];
}


- (void)complaintInfoList:(NSString *)student teacherId:(NSString *)teacherId reason:(NSString *)reason {
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/complaint",Basicurl];
    NSDictionary *dic = @{@"student":student,@"teacherId":teacherId,@"reason":reason};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"保存投诉成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"complaintInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"保存投诉失败%@",object);
    }];
}

- (void)appointInfoList:(NSString *)courseId studentId:(NSString *)studentId time:(NSString *)time place:(NSString *)place{
    NSString *encoded = [place stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/appoint",Basicurl];
    NSDictionary *dic = @{@"courseId":courseId,@"studentId":studentId,@"time":time,@"place":encoded};
    NSLog(@"%@",dic);
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"预约小课成功%@",object);
        NSLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appointInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"预约小课失败%@",object);
    }];
}

- (void)courseReportInfoList:(NSString *)courseId studentId:(NSString *)studentId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/courseReport?courseId=%@&studentId=%@",Basicurl,courseId,studentId];
    NSLog(@"查看课程报告-----%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"查看课程报告成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"courseReportInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSDictionary *dic = @{@"code":@100};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"courseReportInfoList" object:nil userInfo:dic];
        NSLog(@"查看课程报告失败%@",object);
    }];
}

- (void)homeworkInfoList:(NSString *)student course:(NSString *)course time:(NSString *)time finish:(NSString *)finish remark:(NSString *)remark{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/homework",Basicurl];
    NSDictionary *dic = @{@"student":student,@"course":course,@"time":time,@"finish":finish,@"remark":remark};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"提交作业成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeworkInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"提交作业失败%@",object);
    }];
}


- (void)finishedClassInfoList{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/finishedClass?id=%@",Basicurl,uid];
    NSLog(@"获取历史上课记录%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"历史课程成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedClassInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"历史课程失败%@",object);
    }];
}

- (void)groupClassInfoList:(NSString *)groupId page:(NSString *)page{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/groupClass?id=%@&groupId=%@&page=%@",Basicurl,uid,groupId,page];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"社团对应的上课记录成功%@",object);
        NSLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupClassInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"社团对应的上课记录失败%@",object);
    }];
}


/*!
 *  @brief 去除字典空值
 */
- (NSDictionary *)deleteAllNullValue:(NSDictionary *)dic
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dic.allKeys) {
        if ([[dic  objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

@end
