//
//  CourseCell.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "CourseCell.h"

#import "ClassFrame.h"
#import "ClassS.h"

#import "ClassView.h"


@interface CourseCell ()


@property (nonatomic, weak)ClassView *classView;

@end

@implementation CourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 添加所有子控件
        [self setUpAllChildView];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
    
}

// 添加所有子控件
- (void)setUpAllChildView{
    ClassView *classView = [[ClassView alloc] init];
    [self addSubview:classView];
    _classView = classView;
    
    ClassToolBarView *toolBar = [[ClassToolBarView alloc] init];
    [self addSubview:toolBar];
    _toolBar = toolBar;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)setClassFrame:(ClassFrame *)classFrame{
    _classFrame = classFrame;
    
    _classView.frame = classFrame.classViewFrame;
    _classView.classF = classFrame;
    
    _toolBar.frame = classFrame.toolBarFrame;
  
    
}
@end
