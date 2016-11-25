//
//  LoginController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "LoginController.h"
#import "NavigationView.h"
#import "ForgetPasswordController.h"
#import "WROrganizationController.h"
#import "TabViewController.h"
#import "Register.h"
#import "BPush.h"
#import "NetworkingManager.h"

@interface LoginController ()<UITextFieldDelegate>
@property (nonatomic, strong)Register *gister;
//欢迎
@property (weak, nonatomic) IBOutlet UILabel *greet;
//手机号码
@property (weak, nonatomic) IBOutlet UITextField *mobilePhone;
//密码
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation LoginController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loging:) name:@"loginInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:nil leftButtonImage:[UIImage imageNamed:@"back-key-hei@3x.png"]];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _gister = [[Register alloc] init];
    _mobilePhone.layer.borderWidth = 1;
    _mobilePhone.delegate = self;
    _mobilePhone.keyboardType = UIKeyboardTypeNumberPad;
    _mobilePhone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mobilePhone.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _password.layer.borderWidth = 1;
    _password.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _password.secureTextEntry = YES;
    _password.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}
- (void)loging:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
    
        if ([defailts objectForKey:@"uId"]) {
            
            [BPush registerDeviceToken:[defailts objectForKey:@"deviceToken"]];
            NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/createTag",Basicurl];
            NSDictionary *dic = @{@"id":[defailts objectForKey:@"uId"],@"channelId":[defailts objectForKey:@"deviceToken1"]};
            [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
                NSLog(@"创建百度推送标签成功%@",object);
                
                [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
                    // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
                    
                    // 网络错误
                    if (error) {
                        return ;
                    }
                    if (result) {
                        // 确认绑定成功
                        if ([result[@"error_code"]intValue]!=0) {
                            return;
                        }
                        // 获取channel_id
                        NSString *myChannel_id = [BPush getChannelId];
                        NSLog(@"==%@",myChannel_id);
                        //获取当前设备应用的tag列表
                        [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                            if (result) {
                                NSLog(@"result ============== %@",result);
                            }
                        }];
                        [BPush setTag:[defailts objectForKey:@"deviceToken1"] withCompleteHandler:^(id result, NSError *error) {
                            if (result) {
                                NSLog(@"设置tag成功");
                            }
                        }];
                    }
                }];
            } failureBlock:^(id object) {
                NSLog(@"创建百度推送标签失败%@",object);
            }];
        }

        TabViewController *mainTab = [[TabViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = mainTab;
    }else{
        [self tooltip:@"密码错误"];
    }

}

//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark --按钮事件
//登录
- (IBAction)login:(UIButton *)sender {
    if (_mobilePhone.text.length == 0) {
        [self tooltip:@"电话号码不能为空"];
    }else if (_password.text.length == 0){
        [self tooltip:@"密码不能为空"];
    }else if ([CManager validateMobile:_mobilePhone.text]){
        [_gister loginInfoList:_mobilePhone.text pass:_password.text];
    }else{
        [self tooltip:@"电话号码不正确"];
    }
}
//忘记密码
- (IBAction)forget:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgetPasswordController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"ForgetPasswordController"];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mobilePhone) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    
    return YES;
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
