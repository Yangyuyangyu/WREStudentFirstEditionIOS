//
//  RrecedenceCell.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/4.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RrecedenceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titel;
//排名
@property (weak, nonatomic) IBOutlet UILabel *ranking;
//评分
@property (weak, nonatomic) IBOutlet UILabel *score;
//圆
@property (weak, nonatomic) IBOutlet UIView *round;

@end
