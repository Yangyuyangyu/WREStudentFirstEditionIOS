//
//  FeedbackController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "FeedbackController.h"
#import "NavigationView.h"
#import "MySelf.h"

@interface FeedbackController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)MySelf *myself;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic, assign) CGFloat lin;
//邮箱
@property (weak, nonatomic) IBOutlet UITextField *email;
@end

@implementation FeedbackController
//移除通知
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"意见反馈" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _lin = _line.constant;
    _contentLabel.enabled = NO;
    _contentLabel.text = @"请在这里填写建议，我们重视每个反馈的声音，我们将不断改进，感谢您的支持！";
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentTextView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_email setValue:[UIColor colorWithWhite:0.533 alpha:1.000] forKeyPath:@"_placeholderLabel.textColor"];
    _email.delegate = self;
    _myself = [[MySelf alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(feedback:) name:@"feedbackInfokInfoList" object:nil];
}

- (void)feedback:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"反馈成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//提交
- (IBAction)submit:(UIButton *)sender {
    
    if (_contentTextView.text.length == 0) {
        [self tooltip:@"反馈不能为空"];
    }else{
        if (_email.text.length == 0){
            _email.text = @"";
            NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
            [_myself feedbackInfokInfoList:uid content:_contentTextView.text email:_email.text];
        }else{
            if (![CManager validateEmail:_email.text]) {
                [self tooltip:@"邮箱格式不正确"];
            }else{
                NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
                [_myself feedbackInfokInfoList:uid content:_contentTextView.text email:_email.text];
            }
        }
        
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
    self.contentTextView.text =  textView.text;
    if (textView.text.length == 0) {
        _contentLabel.text = @"请在这里填写建议，我们重视每个反馈的声音，我们将不断改进，感谢您的支持！";
    }else{
        _contentLabel.text = @"";
    }
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 300 - (self.view.frame.size.height - 216.0);//键盘高度216
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
//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
