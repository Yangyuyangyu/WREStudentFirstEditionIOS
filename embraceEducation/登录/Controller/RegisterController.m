//
//  RegisterController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "RegisterController.h"
#import "NavigationView.h"
#import "Register.h"
#import "LoginController.h"
#import "AgreementController.h"

@interface RegisterController ()<UITextFieldDelegate>

@property (nonatomic, strong)Register *gister;
//注册label
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
//电话号码
@property (weak, nonatomic) IBOutlet UITextField *phone;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *authCode;
//密码
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, copy)NSString *log_id;

@property (nonatomic, assign) BOOL isAgreed;

@property (weak, nonatomic) IBOutlet UIButton *agreement;

@end

@implementation RegisterController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendCode:) name:@"sendCodeInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"registerInfoList" object:nil];
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
    _password.layer.borderWidth = 1;
    _password.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _password.secureTextEntry = YES;
    _phone.layer.borderWidth = 1;
    _phone.delegate = self;
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _authCode.keyboardType = UIKeyboardTypeNumberPad;
    _authCode.delegate = self;
    _phone.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _gister = [[Register alloc] init];
    
}
//刷新用户信息
- (void)sendCode:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _log_id = bitice.userInfo[@"log_id"];
        NSLog(@"%@",_log_id);
    }
}

- (void)refresh:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]) {
        [self tooltip:@"用户已经存在"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-2)]){
        [self tooltip:@"验证码错误"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-3)]){
        [self tooltip:@"注册失败请重新注册"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginController * loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginController"];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
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
#pragma mark--按钮点击
//获取验证码
- (IBAction)authCode:(UIButton *)sender {
    if ([CManager validateMobile:_phone.text]) {
        [_gister sendCodeInfoList:_phone.text];
        __block int timeout = 59;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                    sender.enabled = YES;
                });
            }else{
                //            int minutes = timeout / 60;
                            int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    sender.titleLabel.font = [UIFont systemFontOfSize:14];
                    [sender setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                    sender.enabled = NO;
                    
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        
        sender.enabled = NO;

    }else if (_phone.text.length == 0){
        [self tooltip:@"手机号码不能为空"];
    }else {
        [self tooltip:@"手机号码格式不正确"];
    }

    
}
//注册
- (IBAction)Register:(UIButton *)sender {
    if (_password.text.length == 0) {
        [self tooltip:@"密码不能为空"];
    }else if (_password.text.length < 6 || _password.text.length > 20){
        [self tooltip:@"密码必须大于6位小于20位"];
    }else if (_authCode.text.length == 0){
        [self tooltip:@"验证码不能为空"];
    }else if (_phone.text.length == 0){
        [self tooltip:@"手机号码不能为空"];
    }else {
        if (_isAgreed == YES) {
             [_gister registerInfoList:_phone.text pass:_password.text code:_authCode.text log_id:_log_id];
        }else{
            [self tooltip:@"是否同意服务协议"];
        }
       
    }
}
//声明
- (IBAction)statement:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AgreementController * loginVC = [mainSB instantiateViewControllerWithIdentifier:@"AgreementController"];
    loginVC.isStatement = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
//协议
- (IBAction)agreement:(UIButton *)sender {
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AgreementController * loginVC = [mainSB instantiateViewControllerWithIdentifier:@"AgreementController"];
    loginVC.isStatement = NO;
    [self.navigationController pushViewController:loginVC animated:YES];
}
//同意按钮
- (IBAction)agreed:(UIButton *)sender {
    if (!_agreement.selected) {
        _agreement.selected = !_agreement.selected;
        _isAgreed = YES;
    }else{
        _agreement.selected = !_agreement.selected;
        _isAgreed = NO;
    }
}

//限制输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phone) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }else if (textField == self.authCode){
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
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
