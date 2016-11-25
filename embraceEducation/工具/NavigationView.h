//
//  NavigationView.h
//  
//
//  Created by afaga on 14/12/24.
//  Copyright © 2014年 肖恩. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonAction)(void);
@interface NavigationView : UIView

@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIButton *leftButton;
// 如果没有右按钮，则这个属性为nil
@property (nonatomic, strong, readonly) UIButton *rightButton;


@property (nonatomic, copy) ButtonAction leftButtonAction;
@property (nonatomic, copy) ButtonAction rightButtonAction;

- (instancetype)initWithTitle:(NSString *)title leftButtonImage:(UIImage *)leftButtonImage rightButtonImage:(UIImage *)rightButtonImage;

- (instancetype)initWithTitle:(NSString *)title leftButtonImage:(UIImage *)leftButtonImage;

@end
