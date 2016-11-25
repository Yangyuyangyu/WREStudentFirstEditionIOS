//
//  AskLeaveController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AskLeaveController.h"
#import "NavigationView.h"
#import "CZCover.h"
#import "CZPopMenu.h"
#import "Course.h"
static NSString *identify = @"CELL";
@interface AskLeaveController ()<UITableViewDataSource, UITableViewDelegate, CZCoverDelegate, UITextViewDelegate>{
    NSArray *infoArray;
}
//请假原因
@property (weak, nonatomic) IBOutlet UILabel *leave;
//请假类型
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
//开始时间
@property (weak, nonatomic) IBOutlet UILabel *startTime;
//结束时间
@property (weak, nonatomic) IBOutlet UILabel *endTime;

@property (nonatomic, strong) UIDatePicker *pickView;

//弹出Tab
@property (nonatomic, strong)UITableView *czTabel;
@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)Course *course;

@property (nonatomic, assign)BOOL isdate;
//请假类型对应的标号
@property (nonatomic, copy)NSString *typeNumber;

@end

@implementation AskLeaveController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leave:) name:@"leaveInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"请假" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
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
    
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
    }
    infoArray = @[@"事假",@"病假",@"其他"];
    _isdate = NO;
    _typeNumber = @"0";
    _type.text = infoArray[0];
    _leave.enabled = NO;//lable必须设置为不可用
    _course = [[Course alloc] init];
    _leave.backgroundColor = [UIColor clearColor];
    _contentTextView.delegate = self;
    
}
- (void)leave:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请假提交成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark--UITableViewDataSource, UITableViewDelegate, CZCoverDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = infoArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _type.text = infoArray[indexPath.row];
    _typeNumber = [NSString stringWithFormat:@"%ld",((long)indexPath.row + 1)];
    [_cover remove];
}
//让分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

//请假类型
- (IBAction)chooseType:(UIButton *)sender {
    // 弹出蒙板
    _cover = [CZCover show];
    _cover.delegate = self;
    [self.view addSubview:_cover];
    [_cover addSubview:self.czTabel];

}
//开始按钮
- (IBAction)startTime:(UIButton *)sender {
    [self masking];
    _isdate = YES;
    
    
}
//结束按钮
- (IBAction)endTime:(UIButton *)sender {
    [self masking];
    _isdate = NO;
}

- (void)confirm:(UIButton *)sender{
    NSDate *textmydate = [self.pickView date];
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *showdate =[dateformate stringFromDate:textmydate];
    if (_isdate == YES) {
        _startTime.text = showdate;
    }else{
        _endTime.text = showdate;
    }
    if (_endTime.text.length != 0 && _startTime.text.length != 0) {
        [self compareDate:_startTime.text withDate:_endTime.text];
    }
    
    [_cover remove];
}

- (void)handleEvent:(UIButton *)sender{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    if (_startTime.text.length == 0) {
        [self tooltip:@"请选择开始时间"];
    }else if (_endTime.text.length == 0){
        [self tooltip:@"请选择结束时间"];
    }else if (_contentTextView.text == 0){
        [self tooltip:@"请输入请假原因"];
    }else{
        [_course leaveInfoList:uid courseId:_courseId type:_typeNumber start:_startTime.text end:_endTime.text reason:_contentTextView.text];
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
//比较日期大小
- (void)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            [self tooltip:@"结束时间不能小于开始时间"];
            _endTime.text = @"";
            break;
            //date02=date01
        case NSOrderedSame:
            [self tooltip:@"结束时间不能等于开始时间"];
            _endTime.text = @"";
            break;
        default:
            NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
    }
}



- (void)masking{
    // 弹出蒙板
    _cover = [CZCover show];
    _cover.delegate = self;
    [self.view addSubview:_cover];
    // 弹出pop菜单
    CGFloat popW = XN_WIDTH - 20;
    CGFloat popX = 10;
    CGFloat popH = XN_HEIGHT/3;
    CGFloat popY = XN_HEIGHT/3;
    CZPopMenu *menu = [CZPopMenu showInRect:CGRectMake(popX, popY, popW, popH)];
    menu.layer.cornerRadius = 10;
    menu.layer.masksToBounds = YES;
    menu.backgroundColor = [UIColor whiteColor];
    [_cover addSubview:menu];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(popX, popY, popW, popH)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, CGRectGetMaxY(self.pickView.frame)+3, XN_WIDTH - 30, 35);
    button.backgroundColor =XN_COLOR_GREEN_MINT;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.pickView];
    [view addSubview:button];
    menu.contentView = view;
    
}

// 点击蒙板的时候调用
- (void)coverDidClickCover:(CZCover *)cover
{
    // 隐藏pop菜单
    [CZPopMenu hide];
    
}
#pragma mark--UITextViewDelegate

#pragma mark--UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        _leave.text = @"";
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
        _leave.text = @"请输入请假原因...";
    }else{
        _leave.text = @"";
    }
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark--getter
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(XN_WIDTH - 100, 109, 80, 90)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.rowHeight = 30;
        _czTabel.scrollEnabled = NO;
    }
    return _czTabel;
}

- (UIDatePicker *)pickView{
    if (!_pickView) {
        CGFloat popW = XN_WIDTH - 20;
        CGFloat popH = XN_HEIGHT/3 - 45;
        _pickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, popW, popH)];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        _pickView.locale = locale;
        _pickView.datePickerMode = UIDatePickerModeDateAndTime;
    }
    return _pickView;
}
@end
