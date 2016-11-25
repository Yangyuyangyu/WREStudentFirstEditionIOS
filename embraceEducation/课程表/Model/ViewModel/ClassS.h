//
//  ClassS.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface ClassS : NSObject<MJKeyValue>

/**
 *  信息内容
 */
@property (nonatomic, copy) NSString *text;

/**
 *  配图数组(CZPhoto)
 */
@property (nonatomic, strong) NSArray *pic_urls;


@end
