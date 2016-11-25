//
//  XNRegisterController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "WRLoginrController.h"
#import "RegisterController.h"
#import "LoginController.h"
#import "ForgetPasswordController.h"
@interface WRLoginrController ()


@end

@implementation WRLoginrController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

#pragma mark--按钮点点击事件
//注册
- (IBAction)enroll:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RegisterController * registerVC = [mainSB instantiateViewControllerWithIdentifier:@"RegisterController"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
//登录
- (IBAction)login:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginController * loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}
//忘记
- (IBAction)forget:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgetPasswordController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"ForgetPasswordController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

@end
