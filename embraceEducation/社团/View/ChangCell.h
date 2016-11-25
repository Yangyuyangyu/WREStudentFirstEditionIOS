//
//  ChangCell.h
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/10.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
//科目
@property (weak, nonatomic) IBOutlet UILabel *subjects;
//简介
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@property (weak, nonatomic) IBOutlet UIButton *chang;
@end
