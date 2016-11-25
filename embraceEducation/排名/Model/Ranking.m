//
//  Ranking.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/9.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "Ranking.h"
#import "NetworkingManager.h"

@implementation Ranking

- (void)scoreInfoList:(NSString *)courseId studentId:(NSString *)studentId{
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/score?courseId=%@&studentId=%@",Basicurl,courseId,studentId];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"成绩排名成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"成绩排名失败%@",object);
    }];
}

- (void)myScoreInfoList:(NSString *)courseId studentId:(NSString *)studentId{
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/myScore?courseId=%@&studentId=%@",Basicurl,courseId,studentId];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"成绩详情成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myScoreInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"成绩详情失败%@",object);
    }];
}

- (void)rankInfoList{
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/rank?sid=%@",Basicurl,uid];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"社团排名成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"rankInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"社团排名失败%@",object);
    }];
}

- (void)groupRankInfoList:(NSString *)groupId{
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/groupRank?groupId=%@&studentId=%@",Basicurl,groupId,uid];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"某个社团的排名信息成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupRankInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"某个社团的排名信息失败%@",object);
    }];
}

@end
