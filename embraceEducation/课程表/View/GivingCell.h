//
//  GivingCell.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/3.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GivingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
//课程名称
@property (weak, nonatomic) IBOutlet UILabel *week;
//type：类型，1表示大课，2表示小课
@property (weak, nonatomic) IBOutlet UILabel *big;
//状态
@property (weak, nonatomic) IBOutlet UILabel *state;
//评价
@property (weak, nonatomic) IBOutlet UIButton *evaluationButton;

//class_time
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *sign;
//查看课程报告
@property (weak, nonatomic) IBOutlet UIButton *report;
@property (weak, nonatomic) IBOutlet UIView *reportView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *evaluationLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateLine;
@end
