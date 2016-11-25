//
//  WROrganizCell.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WROrganizCell : UITableViewCell
//内容图片
@property (weak, nonatomic) IBOutlet UIImageView *contentPic;
@property (weak, nonatomic) IBOutlet UILabel *titel;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
//简介
@property (weak, nonatomic) IBOutlet UILabel *intro;
//审核图片
@property (weak, nonatomic) IBOutlet UIImageView *auditPic;
@end
