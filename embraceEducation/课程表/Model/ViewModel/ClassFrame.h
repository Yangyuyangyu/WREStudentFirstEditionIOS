//
//  ClassFrame.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ClassS;
@interface ClassFrame : NSObject

@property (nonatomic, strong)ClassS *classS;

@property (nonatomic, assign)CGRect classViewFrame;

@property (nonatomic, assign)CGRect textFrame;

@property (nonatomic, assign)CGRect photosFrame;

// 工具条frame
@property (nonatomic, assign) CGRect toolBarFrame;

@property (nonatomic, assign)CGFloat cellHeight;

@end
