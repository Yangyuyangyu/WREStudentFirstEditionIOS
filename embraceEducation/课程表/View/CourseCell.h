//
//  CourseCell.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassToolBarView.h"
@class ClassFrame;
@interface CourseCell : UITableViewCell

@property (nonatomic, strong)ClassFrame *classFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak)ClassToolBarView *toolBar;
@end
