//
//  ForgetPasswordController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "NavigationView.h"
#import "Register.h"
#import "LoginController.h"
#import "RegisterController.h"

@interface ForgetPasswordController ()<UITextFieldDelegate>
@property (nonatomic, strong)Register *gister;
//忘记密码Label
@property (weak, nonatomic) IBOutlet UILabel *forgetPassword;
//电话号码
@property (weak, nonatomic) IBOutlet UITextField *phone;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *authCode;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *newlyPassword;
@property (weak, nonatomic) IBOutlet UITextField *newlyPassword1;
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *background;
//验证码
@property (weak, nonatomic) IBOutlet UIButton *gain;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic , assign)CGFloat lin;

@property (nonatomic, copy)NSString *log_id;

@end

@implementation ForgetPasswordController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(findPwd:) name:@"findPwdfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendCode:) name:@"sendCodeInfoList" object:nil];
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
    _lin = _line.constant;
    _gister = [[Register alloc] init];
    _phone.layer.borderWidth = 1;
    _phone.delegate = self;
    _phone.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    _phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _newlyPassword.layer.borderWidth = 1;
    _newlyPassword.delegate = self;
    _newlyPassword.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _newlyPassword1.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newlyPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authCode.delegate = self;
    _authCode.keyboardType = UIKeyboardTypeNumberPad;
    _newlyPassword.secureTextEntry = YES;
    _newlyPassword1.secureTextEntry = YES;
    _newlyPassword1.layer.borderWidth = 1;
    _newlyPassword1.delegate = self;
    _newlyPassword1.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        _line.constant = -offset;
    }
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _line.constant = _lin;
    }];
}


- (void)sendCode:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _log_id = bitice.userInfo[@"log_id"];
        NSLog(@"%@",_log_id);
    }
}
- (void)findPwd:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"修改成功，是否立即登录" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginController * loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginController"];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        UIAlertAction *actionq = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionq];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"此号码未注册，是否马上注册" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RegisterController * registerVC = [mainSB instantiateViewControllerWithIdentifier:@"RegisterController"];
            [self.navigationController pushViewController:registerVC animated:YES];
        }];
        UIAlertAction *actionq = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionq];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-2)]){
        [self tooltip:@"验证码错误"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-3)]){
        [self tooltip:@"修改失败"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-4)]){
        [self tooltip:@"已成功注册为新用户"];
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginController * loginVC = [mainSB instantiateViewControllerWithIdentifier:@"LoginController"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

#pragma mark--按钮点击事件
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
//                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
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
//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
//确认
- (IBAction)affirm:(UIButton *)sender {
    if (_newlyPassword.text.length == 0 || _newlyPassword1.text.length == 0) {
        [self tooltip:@"密码不能为空"];
    }else if ((_newlyPassword.text.length < 6 || _newlyPassword.text.length > 20) || _newlyPassword1.text.length < 6 || _newlyPassword1.text.length > 20){
        [self tooltip:@"密码必须大于6位小于20位"];
    }else if (_authCode.text.length == 0){
        [self tooltip:@"验证码不能为空"];
    }else if (_phone.text.length == 0){
        [self tooltip:@"手机号码不能为空"];
    }else if (![_newlyPassword.text isEqualToString:_newlyPassword1.text]){
        [self tooltip:@"两次输入的密码不相同"];
    }else {
        [_gister findPwdfoList:_phone.text code:_authCode.text pass:_newlyPassword.text log_id:_log_id];
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
