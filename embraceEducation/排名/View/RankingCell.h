//
//  RankingCell.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/3.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
//机构学校
@property (weak, nonatomic) IBOutlet UILabel *school;
//社团
@property (weak, nonatomic) IBOutlet UILabel *team;

@property (weak, nonatomic) IBOutlet UILabel *di;
@property (weak, nonatomic) IBOutlet UILabel *min;
//名次
@property (weak, nonatomic) IBOutlet UILabel *number;

@end
