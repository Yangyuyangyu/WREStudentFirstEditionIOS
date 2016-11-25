//
//  FriendController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/4.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "FriendController.h"
#import "NavigationView.h"
#import "MySelf.h"

@interface FriendController ()

@property(nonatomic, strong)MySelf *myself;
//邀请方式
@property (weak, nonatomic) IBOutlet UILabel *way;
@property (weak, nonatomic) IBOutlet UIView *backView;
//线
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet UITextField *invitation;

@end

@implementation FriendController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(invite:) name:@"inviteInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"邀请好友" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    _myself = [[MySelf alloc]init];
    
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    
}

- (void)invite:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        [self tooltip:@"短信发送成功"];
    }
}
//微信
- (IBAction)tiny:(UIButton *)sender {
    [self tooltip:@"暂未开放"];
}
//qq
- (IBAction)qq:(UIButton *)sender {
    [self tooltip:@"暂未开放"];
}
//朋友圈
- (IBAction)friend:(UIButton *)sender {
    [self tooltip:@"暂未开放"];
}
//发送
- (IBAction)send:(UIButton *)sender {
    if ([CManager validateMobile:_invitation.text]) {
         [_myself inviteInfoList:_invitation.text];
    }else{
        [self tooltip:@"电话号码错误"];
    }
   
}
#pragma mark--自定义方法
//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
