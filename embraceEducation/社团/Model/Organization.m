//
//  Organization.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/6.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "Organization.h"
#import "NetworkingManager.h"

@implementation Organization

- (void)myGroupInfoList:(NSString *)uid page:(NSString *)page{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/myGroup?id=%@&page=%@",Basicurl,uid,page];
    NSLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"已加入的社团成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"myGroupInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"已加入的社团失败%@",object);
    }];
}

- (void)groupInfoList1:(NSString *)type{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/group?type=%@",Basicurl,type];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"搜索社团成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"搜索社团失败%@",object);
    }];
}

- (void)groupInfoList:(NSString *)type name:(NSString *)name{
    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/group?type=%@&name=%@",Basicurl,type,encoded];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"搜索社团成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"搜索社团失败%@",object);
    }];
}

- (void)joinGroupInfoList:(NSString *)groupId studentId:(NSString *)studentId subjectId:(NSString *)subjectId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/joinGroup",Basicurl];
    NSDictionary *dic = @{@"groupId":groupId,@"studentId":studentId,@"subjectId":subjectId};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"申请加入社团成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"joinGroupInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"申请加入社团失败%@",object);
    }];
}

- (void)agencyDetailInfoList:(NSString *)agencyId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/agencyDetail?agencyId=%@",Basicurl,agencyId];
    NSLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"机构详情成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"agencyDetailInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"机构详情失败%@",object);
    }];
}

- (void)groupDetailInfoList:(NSString *)groupId studentId:(NSString *)studentId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/groupDetail?groupId=%@&studentId=%@",Basicurl,groupId,studentId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"社团详情成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupDetailInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"社团详情失败%@",object);
    }];
}

- (void)newsDetailInfoList:(NSString *)newsId {
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/newsDetail?newsId=%@",Basicurl,newsId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"社团动态详情成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newsDetailInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"社团动态详情失败%@",object);
    }];
}

- (void)ruleInfoList:(NSString *)groupId {
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/rule?groupId=%@",Basicurl,groupId];
    NSLog(@"%@",urlstr);
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"社团管理制度成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ruleInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSDictionary *dic = @{@"code":@100};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ruleInfoList" object:nil userInfo:dic];
        NSLog(@"社团管理制度失败%@",object);
    }];
}

- (void)groupBuildInfoList:(NSString *)groupId {
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/groupBuild?groupId=%@",Basicurl,groupId];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"社团建设成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"groupBuildInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"社团建设失败%@",object);
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
