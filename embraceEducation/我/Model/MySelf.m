//
//  MySelf.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/9.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "MySelf.h"
#import "NetworkingManager.h"
#import "AFNetworking.h"

@implementation MySelf

- (void)studentInfoList:(NSString *)studentId {
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/studentInfo?studentId=%@",Basicurl,studentId];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"学生个人信息成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"studentInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"学生个人信息失败%@",object);
    }];
}

- (void)editInfokInfoList:(NSString *)uid head_img:(NSString *)head_img name:(NSString *)name sex:(NSString *)sex birthday:(NSString *)birthday home:(NSString *)home{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/editInfo",Basicurl];
    NSDictionary *dic = @{@"id":uid,@"head_img":head_img,@"name":name,@"sex":sex,@"birthday":birthday,@"home":home};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"修改个人信息成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editInfokInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"修改个人信息失败%@",object);
    }];
}


- (void)aboutUsInfoList {
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/aboutUs",Basicurl];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"关于我们成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"aboutUsInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"关于我们失败%@",object);
    }];
}

- (void)messageInfoList {
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/message?studentId=%@",Basicurl,uid];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"消息中心成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"messageInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"消息中心失败%@",object);
    }];
}

- (void)editPwdInfokInfoList:(NSString *)student oldPass:(NSString *)oldPass newPass:(NSString *)newPass {
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/editPwd",Basicurl];
    NSDictionary *dic = @{@"student":student,@"oldPass":oldPass,@"newPass":newPass};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"修改密码成功%@",object);
        NSLog(@"%@",object[@"msg"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editPwdInfokInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"修改密码失败%@",object);
    }];
}

- (void)feedbackInfokInfoList:(NSString *)student content:(NSString *)content email:(NSString *)email {
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/feedback",Basicurl];
    NSDictionary *dic = @{@"student":student,@"content":content,@"email":email};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"意见反馈成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"feedbackInfokInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"意见反馈失败%@",object);
    }];
}

- (void)inviteInfoList:(NSString *)mobile {
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/invite?mobile=%@",Basicurl,mobile];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"短信邀请好友成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"inviteInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"短信邀请好友失败%@",object);
    }];
}

- (void)imgUploadInfokInfoList:(NSData *)name {

    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/CommonApi/imgUpload",Basicurl];
    NSDictionary *dic = @{@"name":name};
    [session POST:urlstr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:name name:@"pic" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        NSLog(@"%@",uploadProgress);//进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"图片上传接口成功%@",responseObject);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imgUploadInfokInfoList" object:nil userInfo:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片上传接口失败%@",error);
    }];
}

- (void)createTagInfokInfoList:(NSString *)uid channelId:(NSString *)channelId{
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/createTag",Basicurl];
    NSDictionary *dic = @{@"id":uid,@"channelId":channelId};
    [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
        NSLog(@"创建百度推送标签成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createTagInfokInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"创建百度推送标签失败%@",object);
    }];
}

- (void)pushMessageInfoList:(NSString *)uid {
    //    NSString *encoded = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/invite?id=%@",Basicurl,uid];
    NSLog(@"%@",urlstr);
    
    [NetworkingManager sendGetRequestWithURL:urlstr parametesDic:nil successBlock:^(id object) {
        NSLog(@"推送消息成功%@",object);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushMessageInfoList" object:nil userInfo:object];
    } failureBlock:^(id object) {
        NSLog(@"推送消息失败%@",object);
    }];
}
@end
