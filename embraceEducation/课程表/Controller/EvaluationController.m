//
//  evaluationController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/13.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "EvaluationController.h"
#import "NavigationView.h"
#import "Course.h"

@interface EvaluationController ()<UITextViewDelegate>

@property (nonatomic, strong)Course *course;

@property (weak, nonatomic) IBOutlet UILabel *evluationLabel;
@property (weak, nonatomic) IBOutlet UITextView *evluationTextView;

@end

@implementation EvaluationController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(confirm:) name:@"commentInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"评价" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
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
    
    _course = [[Course alloc]init];
    
    _evluationLabel.enabled = NO;
    _evluationLabel.backgroundColor = [UIColor clearColor];
    _evluationTextView.delegate = self;
    
    
}
- (void)confirm:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提交评价成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)handleEvent:(UIButton *)sender{
    if (_evluationTextView.text.length == 0) {
        [self tooltip:@"评价内容不能为空"];
    }else{
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
        [_course commentInfoList:_recordId studentId:uid content:_evluationTextView.text];
    }
}


#pragma mark--UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        _evluationLabel.text = @"";
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
    self.evluationTextView.text =  textView.text;
    if (textView.text.length == 0) {
        _evluationLabel.text = @"请输入对老师的意见与建议";
    }else{
        _evluationLabel.text = @"";
    }
}

#pragma mark--自定义方法
//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
