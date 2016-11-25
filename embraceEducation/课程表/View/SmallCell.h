//
//  SmallCell.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/3.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UILabel *small;


@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *appointment;
@end
