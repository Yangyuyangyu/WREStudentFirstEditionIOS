//
//  SubmitJobController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/16.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "SubmitJobController.h"
#import "NavigationView.h"
#import "Course.h"
#import "CManager.h"

@interface SubmitJobController ()<UITextViewDelegate>
@property (nonatomic, strong)Course *course;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *noCompleteButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, copy)NSString *isComplete;
@property (nonatomic, assign)BOOL isTextView;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet UILabel *TextviewLabel;
@end

@implementation SubmitJobController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(homework:) name:@"homeworkInfoList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (_isTextView == YES) {
        _isTextView = NO;
        CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
        NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        int offset = 0;
        if (XN_WIDTH == 320) {
            offset = _backView.frame.size.height - keyboardRect.size.height + 50;//键盘高度216
        }else{
            offset = _backView.frame.size.height - keyboardRect.size.height + 0;//键盘高度216
        }
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        if(offset > 0){
            _line.constant = -offset;
        }
        [UIView commitAnimations];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:animationDuration animations:^{
        _line.constant = 64;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:_titel leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _isTextView = NO;
    _isComplete = @"0";
    _course = [[Course alloc] init];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _TextviewLabel.enabled = NO;//lable必须设置为不可用
    _TextviewLabel.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 60, 30, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    [_completeButton setImage:[[UIImage imageNamed:@"choose12x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState: UIControlStateNormal];
    [_completeButton setImage:[[UIImage imageNamed:@"choose2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    [_noCompleteButton setImage:[[UIImage imageNamed:@"choose12x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState: UIControlStateNormal];
    [_noCompleteButton setImage:[[UIImage imageNamed:@"choose2x.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    _noCompleteButton.selected = !_noCompleteButton.selected;
    
    
}

- (void)homework:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提交成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
- (void)handleEvent:(UIButton *)sender{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    if ([CManager checkNum:_textField.text]) {
       [_course homeworkInfoList:uid course:_courseId time:_textField.text finish:_isComplete remark:_textView.text];
    }else{
        [self tooltip:@"请输入数字"];
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
- (IBAction)complete:(UIButton *)sender {
    if (!sender.selected) {
        _isComplete = @"1";
        _completeButton.selected = !_completeButton.selected;
        _noCompleteButton.selected = !_noCompleteButton.selected;
    }
}
- (IBAction)noComplete:(UIButton *)sender {
    if (!sender.selected) {
        _completeButton.selected = !_completeButton.selected;
        _noCompleteButton.selected = !_noCompleteButton.selected;
        _isComplete = @"0";
    }
    
}

#pragma mark--UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _isTextView = YES;
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        _TextviewLabel.text = @"";
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
    self.textView.text =  textView.text;
    if (textView.text.length == 0) {
        _TextviewLabel.text = @"请输入你的备注";
    }else{
        _TextviewLabel.text = @"";
    }
}
//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
