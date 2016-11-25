//
//  NetworkingManager.m
//  网络请求
//
//  Created by manf on 14/11/30.
//  Copyright © 2014年 肖恩. All rights reserved.
//

#import "NetworkingManager.h"
#import <AFNetworking.h>
#import <AFHTTPSessionManager.h>
@implementation NetworkingManager


+ (void)sendGetRequestWithURL:(NSString *)utlString parametesDic:(NSDictionary *)parameters successBlock:(NetBlock)successBlock failureBlock:(NetBlock)failureBlock {
  
    //初始化网络参数
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //配置Manager
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    配置超时时间
    sessionManager.requestSerializer.timeoutInterval = 60;
    //配置返回格式
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/javascript", nil];
     //    GET方法
    [sessionManager GET:utlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error.localizedDescription);
        }
    }];

}

+ (void)sendPOSTRequesWithURL:(NSString *)urlString parameters:(NSDictionary *)parameters successBlock:(NetBlock)successBlock failureBlock:(NetBlock)failureBlock {
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
//    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = 30.0;
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/javascript", nil];
    [sessionManager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error.localizedDescription);
        }
    }];

}


@end
