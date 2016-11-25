//
//  NetworkingManager.h
//  网络请求
//
//  Created by manf on 14/11/30.
//  Copyright © 2014年 肖恩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetBlock)(id object);

@interface NetworkingManager : NSObject
+ (void)sendGetRequestWithURL:(NSString *)utlString
                 parametesDic:(NSDictionary *)parameters
                 successBlock:(NetBlock)successBlock
                 failureBlock:(NetBlock)failureBlock;

+ (void)sendPOSTRequesWithURL:(NSString *)urlString
                   parameters:(NSDictionary *)parameters
                 successBlock:(NetBlock)successBlock
                 failureBlock:(NetBlock)failureBlock;

@end
