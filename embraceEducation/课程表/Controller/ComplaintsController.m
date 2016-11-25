//
//  ComplaintsController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ComplaintsController.h"
#import "NavigationView.h"
#import "Course.h"

@interface ComplaintsController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *teacherNameLabel;
//投诉内容
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong)Course *course;

@end

@implementation ComplaintsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(complaint:) name:@"complaintInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"投诉" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 60, 30, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _teacherNameLabel.text = _name;
    _contentLabel.enabled = NO;//lable必须设置为不可用
    _course = [[Course alloc] init];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _content.delegate = self;
    
}


- (void)complaint:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"投诉提交成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark--UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        _contentLabel.text = @"";
        //        如果输入有中文，且没有出现文字备选框就对字数统计和限制
        //        出现了备选框就暂不统计
        UITextRange *range = [textView markedTextRange];
        
        UITextPosition *position = [textView positionFromPosition:range.start offset:0];
        if (!position)
        {
            
            [self checkText:textView];
            
        }
    }
    else
    {
        [self checkText:textView];
    }
}

- (void)checkText:(UITextView *)textView{
    self.content.text =  textView.text;
    if (textView.text.length == 0) {
        _contentLabel.text = @"请输入投诉原因...";
    }else{
        _contentLabel.text = @"";
    }
}

- (void)handleEvent:(UIButton *)sender{
    if (_teacherId.length == 0) {
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"网络中断" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (_content.text.length == 0){
        [self tooltip:@"请输入投诉原因"];
    }else{
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
        [_course complaintInfoList:uid teacherId:_teacherId reason:_content.text];
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
