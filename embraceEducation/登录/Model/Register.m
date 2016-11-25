//
//  Register.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/6.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "Register.h"
#import "NetworkingManager.h"

@implementation Register

- (void)sendCodeInfoList:(NSString *)mobile{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/sendCode?mobile=%@",Basicurl,mobile];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"验证码成功%@",object);
        NSLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendCodeInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"验证码失败%@",object);
    }];
}

- (void)registerInfoList:(NSString *)mobile pass:(NSString *)pass code:(NSString *)code log_id:(NSString *)log_id{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/register",Basicurl];
    NSDictionary *dic = @{@"mobile":mobile,@"pass":pass,@"code":code,@"log_id":log_id};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"注册成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"registerInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"注册失败%@",object);
    }];
}

- (void)loginInfoList:(NSString *)mobile pass:(NSString *)pass{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/login?mobile=%@&pass=%@",Basicurl,mobile,pass];
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"登录成功%@",object);
//        存入学生id
        NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
        [defailts setObject:object[@"data"][@"id"] forKey:@"uId"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"登录失败%@",object);
    }];
}

- (void)findPwdfoList:(NSString *)mobile code:(NSString *)code pass:(NSString *)pass log_id:(NSString *)log_id{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/findPwd?mobile=%@&code=%@&pass=%@&log_id=%@",Basicurl,mobile,code,pass,log_id];
    NSDictionary *dic = @{@"mobile":mobile,@"pass":pass,@"code":code,@"log_id":log_id};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"找回密码成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"findPwdfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
         NSLog(@"找回密码失败%@",object);
    }];
}
//字典转json格式字符串：
+ (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

@end
