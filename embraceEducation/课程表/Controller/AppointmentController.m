//
//  AppointmentController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/3.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AppointmentController.h"
#import "CZCover.h"
#import "CZPopMenu.h"
#import "Course.h"

static NSString *identify = @"CELL";
@interface AppointmentController ()<CZCoverDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)Course *course;

@property (weak, nonatomic) IBOutlet UILabel *titel;
//地点
@property (weak, nonatomic) IBOutlet UITextField *place;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic, strong)UIDatePicker *pickView;

@property (weak, nonatomic) IBOutlet UITableView *tabView;

@property (nonatomic, strong) NSMutableArray *history;
@end

@implementation AppointmentController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appoint:) name:@"appointInfoList" object:nil];
    NSArray *arrau = [[NSUserDefaults standardUserDefaults]objectForKey:@"history"];
    [_history addObjectsFromArray:arrau];
    NSLog(@"aaaaaaaaaaaaaaaaaaaaaaaa%@",_history);
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _place.delegate = self;
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.tableFooterView = [[UIView alloc] init];
    _tabView.hidden = YES;
    _course = [[Course alloc] init];
    _history = [NSMutableArray array];
}


- (void)appoint:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSArray *array = [NSArray array];
        if (_history.count == 0) {
            [_history addObject:_place.text];
        }else{
            int j = 0;
            for (int i = 0; i < _history.count; i ++) {
                j ++;
                if ([_history[i] isEqualToString:_place.text]) {
                    [_history removeObjectAtIndex:i];
                    j --;
                    [_history insertObject:_place.text atIndex:0];
                }
            }
            if (j == _history.count) {
                [_history insertObject:_place.text atIndex:0];
            }
        }
        array = (NSArray *)_history;
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"history"];
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"预约成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-2)]){
        [self tooltip:@"预约的上课时间重复，请修改"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-3)]){
        [self tooltip:@"不能预约过去时间"];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        [self tooltip:@"你最近预约的课程还在上课中，暂时不能预约课程"];
    }
}

#pragma mark--UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _tabView.hidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _history.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _history[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _place.text = _history[indexPath.row];
    _tabView.hidden = YES;
}
/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_history.count == 0) {
        return 0;
    }else{
        return 30;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithWhite:0.255 alpha:1.000];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:15];
    headerLabel.frame = CGRectMake(20, 0.0, 300.0, 44.0);
    headerLabel.text =  @"历史地址记录";
    [customView addSubview:headerLabel];
    
    return customView;
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_place resignFirstResponder];//失去第一响应者
}

- (IBAction)date:(UIButton *)sender {
    [self masking];
}

- (IBAction)submit:(UIButton *)sender {
    if (_place.text.length == 0) {
        [self tooltip:@"请输入上课地点"];
    }else if (_time.text.length == 0){
        [self tooltip:@"请选择上课时间"];
    }else{
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
        [_course appointInfoList:_courseId studentId:uid time:_time.text place:_place.text];
    }
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirm:(UIButton *)sender{
    NSDate *textmydate = [self.pickView date];
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    [dateformate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *showdate =[dateformate stringFromDate:textmydate];
    _time.text = showdate;
    
    [_cover remove];
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

- (void)masking{
    [self.view endEditing:YES];
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

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
