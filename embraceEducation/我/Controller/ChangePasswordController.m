//
//  ChangePasswordController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ChangePasswordController.h"
#import "NavigationView.h"
#import "ShareSingle.h"
#import "MySelf.h"

@interface ChangePasswordController ()
@property (weak, nonatomic) IBOutlet UITextField *oldTextfield;

@property (weak, nonatomic) IBOutlet UITextField *newlyTextfield;
@property (weak, nonatomic) IBOutlet UIButton *eyeButton;

@property (weak, nonatomic) IBOutlet UIButton *eyesButton;

@property (nonatomic, strong)MySelf *myself;

@end

@implementation ChangePasswordController
//移除通知
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"修改密码" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _oldTextfield.secureTextEntry = YES;
    _newlyTextfield.secureTextEntry = YES;
    _oldTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    _newlyTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    [_eyeButton setImage:[[UIImage imageNamed:@"eyes2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState: UIControlStateNormal];
    [_eyeButton setImage:[[UIImage imageNamed:@"eyes12x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [_eyesButton setImage:[[UIImage imageNamed:@"eyes2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState: UIControlStateNormal];
    [_eyesButton setImage:[[UIImage imageNamed:@"eyes12x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    _myself = [[MySelf alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editPwd:) name:@"editPwdInfokInfoList" object:nil];
}

- (void)editPwd:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        [self tooltip:@"新密码与旧密码相同"];
    }
}
//可见不可见
- (IBAction)eye:(UIButton *)sender {
    if (sender.tag == 0) {
        if (sender.selected) {
            _oldTextfield.secureTextEntry = YES;
        }else{
            _oldTextfield.secureTextEntry = NO;
        }
        _eyeButton.selected = !_eyeButton.selected;
    }else{
        if (sender.selected) {
            _newlyTextfield.secureTextEntry = YES;
        }else{
            _newlyTextfield.secureTextEntry = NO;
        }
        _eyesButton.selected = !_eyesButton.selected;
    }
    
}

//确定
- (IBAction)confirm:(UIButton *)sender {
    if (_oldTextfield.text.length == 0) {
        [self tooltip:@"旧密码不能为空"];
    }else if (_newlyTextfield.text.length == 0){
        [self tooltip:@"新密码不能为空"];
    }else if (_newlyTextfield.text.length < 6 || _newlyTextfield.text.length > 20){
        [self tooltip:@"密码必须大于6位小于20位"];
    }else{
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
        [_myself editPwdInfokInfoList:uid oldPass:_oldTextfield.text newPass:_newlyTextfield.text];
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
@end
