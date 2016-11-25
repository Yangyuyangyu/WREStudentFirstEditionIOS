//
//  WRSyllabusViewController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "WRSyllabusController.h"
#import "NavigationView.h"
#import "GivingCell.h"
#import "SmallCell.h"
#import "CourseController.h"
#import "AppointmentController.h"
#import "Course.h"
#import <UIImageView+WebCache.h>
#import "ClassSituationController.h"
#import <MJRefresh.h>
#import "EvaluationController.h"


static NSString *identify1 = @"GivingCell";
static NSString *identify2 = @"SmallCell";
#define XN_COLOUR [UIColor colorWithRed:0.878 green:0.506 blue:0.161 alpha:1.000]
@interface WRSyllabusController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSouce;
    NSArray *weekArray1;
    NSArray *weekArray2;
    NSArray *weekArray3;
    NSArray *weekArray4;
    NSArray *weekArray5;
    NSArray *weekArray6;
    NSArray *weekArray7;
    NSArray *weekArray;
    NSArray *statusArray;
    NSArray *smallClassArray;
}

@property (nonatomic, strong)Course *course;


@property (weak, nonatomic) IBOutlet UIButton *week1;
@property (weak, nonatomic) IBOutlet UIButton *week2;
@property (weak, nonatomic) IBOutlet UIButton *week3;
@property (weak, nonatomic) IBOutlet UIButton *week4;
@property (weak, nonatomic) IBOutlet UIButton *week5;
@property (weak, nonatomic) IBOutlet UIButton *week6;
@property (weak, nonatomic) IBOutlet UIButton *week7;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UITableView *scheduleTab;
@property (nonatomic, assign)NSInteger date;

@property (nonatomic, assign)BOOL isDropDown;//判断是否是下拉刷新
@property (nonatomic, assign)NSInteger subscript;//判断在星期几下拉刷新

@property (nonatomic, assign) NSInteger weekdate;//判断是第几周

@property (nonatomic, strong) NavigationView *navigationView;

@property (nonatomic, assign) NSInteger number;
@end

@implementation WRSyllabusController
//移除通知
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    [_course courseListInfoList:uid week:[NSString stringWithFormat:@"%ld",(long)_weekdate]];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    _view1.backgroundColor = [UIColor whiteColor];
    _view2.backgroundColor = [UIColor whiteColor];
    _view3.backgroundColor = [UIColor whiteColor];
    _view4.backgroundColor = [UIColor whiteColor];
    _view5.backgroundColor = [UIColor whiteColor];
    _view6.backgroundColor = [UIColor whiteColor];
    _view7.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _navigationView = [[NavigationView alloc] initWithTitle:@"课程表(本周)" leftButtonImage:nil];
    [self.view addSubview:_navigationView];
    _scheduleTab.dataSource = self;
    _scheduleTab.delegate = self;
    _isDropDown = NO;
    
    _number = 0;
    _weekdate = 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 80, 30, 80, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"下一周" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.tag = 100;
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 30, 80, 30);
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    [button1 setTitle:@"上一周" forState:UIControlStateNormal];
    [button1 setTintColor:[UIColor whiteColor]];
    button1.tag = 101;
    [button1 addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    _scheduleTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isDropDown = YES;
            NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
            [_course courseListInfoList:uid week:[NSString stringWithFormat:@"%ld",(long)_weekdate]];
            [_scheduleTab.mj_header endRefreshing];//结束刷新
        });
    }];
    
    _course = [[Course alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(courseList:) name:@"courseListInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(confirm:) name:@"confirmInfoList" object:nil];
    dataSouce = [NSArray array];
    weekArray1 = [NSArray array];
    weekArray2 = [NSArray array];
    weekArray3 = [NSArray array];
    weekArray4 = [NSArray array];
    weekArray5 = [NSArray array];
    weekArray6 = [NSArray array];
    weekArray7 = [NSArray array];
    smallClassArray = [NSArray array];
    
}

- (void)confirm:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
        [_course courseListInfoList:uid week:@"0"];
    }
}

- (void)courseList:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        weekArray = nil;
        if (_isDropDown == NO || _subscript == 0) {
            _date = [self getNowWeekday];
        }else{
            _date = _subscript;
        }
        dataSouce = bitice.userInfo[@"data"][@"courseList"];
        smallClassArray = bitice.userInfo[@"data"][@"smallClass"];
        for (int i = 0; i < dataSouce.count; i ++) {
            NSInteger week = [dataSouce[i][@"week"]integerValue];
            NSArray *array = dataSouce[i][@"course"];
            switch (week) {
                case 1:
                    weekArray1 = array;
                    break;
                case 2:
                    weekArray2 = array;
                    break;
                case 3:
                    weekArray3 = array;
                    break;
                case 4:
                    weekArray4 = array;
                    break;
                case 5:
                    weekArray5 = array;
                    break;
                case 6:
                    weekArray6 = array;
                    break;
                case 7:
                    weekArray7 = array;
                    break;
                default:
                    break;
            }
        }
        if (_weekdate == 0) {
            switch (_date) {
                case 1:
                    _view7.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray7;
                    if (_isDropDown == NO) {
                        [_week7 setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                        _number = 7;
                    }
                    break;
                case 2:
                    _view1.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray1;
                    if (_isDropDown == NO) {
                        [_week1 setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                        _number = 1;
                    }
                    break;
                case 3:
                    _view2.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray2;
                    if (_isDropDown == NO) {
                        [_week2 setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                        _number = 2;
                    }
                    break;
                case 4:
                    _view3.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray3;
                    if (_isDropDown == NO) {
                        [_week3 setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                        _number = 3;
                    }
                    break;
                case 5:
                    _view4.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray4;
                    if (_isDropDown == NO) {
                        [_week4 setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                        _number = 4;
                    }
                    break;
                case 6:
                    _view5.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray5;
                    if (_isDropDown == NO) {
                        [_week5 setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                        _number = 5;
                    }
                    break;
                case 7:
                    _view6.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray6;
                    if (_isDropDown == NO) {
                        [_week6 setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                        _number = 6;
                    }
                    break;
                default:
                    break;
            }
        }else{
            switch (_date) {
                case 1:
                    _view7.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray7;
                    break;
                case 2:
                    _view1.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray1;
                    break;
                case 3:
                    _view2.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray2;
                    break;
                case 4:
                    _view3.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray3;
                    break;
                case 5:
                    _view4.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray4;
                    break;
                case 6:
                    _view5.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray5;
                    break;
                case 7:
                    _view6.backgroundColor = XN_COLOR_GREEN_MINT;
                    weekArray = weekArray6;
                    break;
                default:
                    break;
            }
        }
        
        [_scheduleTab reloadData];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        [self tooltip:@"暂无数据"];
        weekArray = nil;
        weekArray1 = nil;
        weekArray2 = nil;
        weekArray3 = nil;
        weekArray4 = nil;
        weekArray5 = nil;
        weekArray6 = nil;
        weekArray7 = nil;
        smallClassArray = nil;
        [_scheduleTab reloadData];
    }
}

#pragma mark--UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return weekArray.count;
    }else{
        return smallClassArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GivingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GivingCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = [self deleteAllNullValue:weekArray[indexPath.row]];
        NSString *pic = dic[@"img"];
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing.png"]];
        cell.time.text = dic[@"class_time"];
        cell.week.text = dic[@"name"];
        
        NSString *type = dic[@"type"];
        NSInteger status = [dic[@"status"]integerValue];
        //        NSInteger status = 5;
        if ([type isEqualToString:@"1"]) {
            cell.big.text = @"(大课)";
            statusArray = @[@"待老师签到",@"待开始上课",@"待点名",@"待老师提交上课报告",@"评价"];
        }else{
            cell.big.text = @"(小课)";
            statusArray = @[@"待老师确认",@"待老师签到",@"待开始上课",@"待老师提交上课报告",@"评价"];
        }
        //学生是否评价课程
        NSNumber *is_comment = dic[@"is_comment"];
        NSString *is_commentStr = is_comment.description;
        //学生是否可以评价
        //        NSNumber *can_comment = dic[@"can_comment"];
        //        NSString *can_commentStr = can_comment.description;
        //        NSString *can_commentStr = @"1";
        //学生是否请假
        NSNumber *leave = dic[@"leave"];
        NSString *leaveStr = [NSString stringWithFormat:@"%@",leave];
        //老师是否请假
        NSNumber *teacher_leave = dic[@"teacher_leave"];
        NSString *teacher_leaveStr = [NSString stringWithFormat:@"%@",teacher_leave];
        //学生是否确认上课
        NSNumber *confirm = dic[@"confirm"];
        NSString *confirmStr = [NSString stringWithFormat:@"%@",confirm];
        //是否可以查看课程报告
        NSNumber *report = dic[@"report"];
        //        NSNumber *report = @1;
        NSString *reportStr = [NSString stringWithFormat:@"%@",report];
        cell.sign.hidden = YES;
        cell.reportView.hidden = YES;
        cell.evaluationButton.hidden = YES;
        if ([teacher_leaveStr isEqualToString:@"1"]) {
            cell.state.text = @"老师已请假";
        }else if ([leaveStr isEqualToString:@"1"]){
            cell.state.text = @"你已请假";
        }else{
            cell.state.text = statusArray[status];
            if (status == 4 && [confirmStr isEqualToString:@"0"] && ![type isEqualToString:@"1"]) {
                cell.sign.layer.borderWidth = 1;
                cell.sign.layer.borderColor = XN_COLOUR.CGColor;
                cell.sign.layer.cornerRadius = 5;
                cell.sign.tag = indexPath.row;
                cell.sign.layer.masksToBounds = YES;
                [cell.sign addTarget:self action:@selector(bigHandleEvent:) forControlEvents:UIControlEventTouchUpInside];
                cell.sign.hidden = NO;
                cell.line.constant += 14;
            }
            if (status == 4 && [reportStr isEqualToString:@"1"]){
                cell.report.tag = indexPath.row;
                [cell.report addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
                cell.reportView.hidden = NO;
                cell.line.constant -= 14;
            }
            if ([is_commentStr isEqualToString:@"1"]) {
                cell.state.hidden = YES;
                cell.evaluationButton.hidden = NO;
                cell.evaluationButton.layer.borderWidth = 1;
                cell.evaluationButton.layer.borderColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
                cell.evaluationButton.layer.cornerRadius = 5;
                cell.evaluationButton.tag = indexPath.row;
                cell.evaluationButton.layer.masksToBounds = YES;
                
                cell.state.textColor = [UIColor colorWithWhite:0.800 alpha:1.000];
                cell.stateLine.constant = 23.5;
            }else{
                //                if (status == 4 && [can_commentStr isEqualToString:@"0"]) {
                //                    cell.state.hidden = YES;
                //                }else
                if (status == 4 ){
                    cell.evaluationButton.hidden = NO;
                    cell.evaluationButton.layer.borderWidth = 1;
                    cell.evaluationButton.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
                    cell.evaluationButton.layer.cornerRadius = 5;
                    cell.evaluationButton.tag = indexPath.row;
                    cell.evaluationButton.layer.masksToBounds = YES;
                    [cell.evaluationButton addTarget:self action:@selector(evaluationButton:) forControlEvents:UIControlEventTouchUpInside];
                    cell.state.textColor = XN_COLOR_GREEN_MINT;
                    cell.stateLine.constant = 23.5;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        SmallCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SmallCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = [self deleteAllNullValue:smallClassArray[indexPath.row]];
        NSString *pic = dic[@"img"];
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing.png"]];
        cell.week.text = dic[@"name"];
        NSString *type = dic[@"type"];
        if ([type isEqualToString:@"1"]) {
            cell.small.text = @"(大课)";
        }else{
            cell.small.text = @"(小课)";
        }
        cell.time.text = dic[@"brief"];
        cell.appointment.layer.cornerRadius = 5;
        cell.appointment.tag = indexPath.row;
        cell.appointment.layer.masksToBounds = YES;
        cell.appointment.layer.borderWidth = 1;
        cell.appointment.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
        [cell.appointment addTarget:self action:@selector(smallHandleEvent:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 40;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithWhite:0.255 alpha:1.000];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.frame = CGRectMake(20, 0.0, 300.0, 44.0);
    UILabel * Label = [[UILabel alloc] initWithFrame:CGRectZero];
    Label.backgroundColor = XN_COLOR_GREEN_MINT;
    Label.frame = CGRectMake(15, 12, 2, 20);
    [customView addSubview:Label];
    if (section == 1) {
        headerLabel.text =  @"小课";
    }else{
        headerLabel.hidden = YES;
    }
    
    [customView addSubview:headerLabel];
    
    return customView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    return customView;
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tabBarController.tabBar.translucent = false;
    _isDropDown = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CourseController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"CourseController"];
    NSDictionary *dic = [NSDictionary dictionary];
    if (weekArray.count == 0) {
        appendVC.Id = @"";
    }else{
        dic = [self deleteAllNullValue:weekArray[indexPath.row]];
        appendVC.Id = dic[@"id"];
    }
    
    if (indexPath.section == 0) {
        appendVC.courseId = dic[@"cid"];
    }else{
        NSDictionary *dic1 = [self deleteAllNullValue:smallClassArray[indexPath.row]];
        appendVC.courseId = dic1[@"id"];
    }
    
    [self.navigationController pushViewController:appendVC animated:YES];
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
#pragma mark--按钮的点击事件
//上下一周
- (void)handleEvent:(UIButton *)sender{
    _isDropDown = YES;
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSArray *array = @[_week1,_week2,_week3,_week4,_week5,_week6,_week7];
    NSArray *nameArray  = @[@"课程表(前三周)",@"课程表(前两周)",@"课程表(前一周)",@"课程表(本周)",@"课程表(后一周)",@"课程表(后两周)",@"课程表(后三周)"];
    if (sender.tag == 100) {
        _weekdate ++;
        if (_weekdate > 3) {
            [self tooltip:@"只能查看后三周的课"];
            _weekdate = 3;
        }else{
            for (int i = 0; i < nameArray.count; i ++) {
                _navigationView.titleLabel.text = nameArray[_weekdate + 3];
                [_navigationView.titleLabel sizeToFit];
            }
        }
        if (_weekdate == 0) {
            for (int i = 0; i < array.count; i ++) {
                if (_number != 0) {
                    [array[_number - 1] setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                }
            }
        }else{
            for (int i = 0; i < array.count; i ++) {
                [array[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        [_course courseListInfoList:uid week:[NSString stringWithFormat:@"%ld",(long)_weekdate]];
    }else{
        _weekdate --;
        if (_weekdate < -3) {
            [self tooltip:@"只能查看前三周的课"];
            _weekdate = -3;
        }else{
            for (int i = 0; i < nameArray.count; i ++) {
                _navigationView.titleLabel.text = nameArray[_weekdate + 3];
                [_navigationView.titleLabel sizeToFit];
            }
        }
        if (_weekdate == 0) {
            for (int i = 0; i < array.count; i ++) {
                if (_number != 0) {
                    [array[_number - 1] setTitleColor:XN_COLOR_GREEN_MINT forState:UIControlStateNormal];
                }
            }
        }else{
            for (int i = 0; i < array.count; i ++) {
                [array[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        [_course courseListInfoList:uid week:[NSString stringWithFormat:@"%ld",(long)_weekdate]];
    }
    _view1.backgroundColor = [UIColor whiteColor];
    _view2.backgroundColor = [UIColor whiteColor];
    _view3.backgroundColor = [UIColor whiteColor];
    _view4.backgroundColor = [UIColor whiteColor];
    _view5.backgroundColor = [UIColor whiteColor];
    _view6.backgroundColor = [UIColor whiteColor];
    _view7.backgroundColor = [UIColor whiteColor];
}

//查看报告
- (void)report:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.translucent = false;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassSituationController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"ClassSituationController"];
    appendVC.courseId = weekArray[sender.tag][@"id"];
    [self.navigationController pushViewController:appendVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//确认上课
- (void)bigHandleEvent:(UIButton *)sender{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    NSString *reportId = weekArray[sender.tag][@"id"];
    NSLog(@"%@",reportId);
    [_course confirmInfoList:reportId sid:uid];
}
//预约小课
- (void)smallHandleEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppointmentController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AppointmentController"];
    appendVC.courseId = smallClassArray[sender.tag][@"id"];
    [self.navigationController pushViewController:appendVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//评价
- (void)evaluationButton:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EvaluationController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"EvaluationController"];
    appendVC.recordId = weekArray[sender.tag][@"id"];
    [self.navigationController pushViewController:appendVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)week:(UIButton *)sender {
    switch (sender.tag) {
        case 2:
            _view1.backgroundColor = XN_COLOR_GREEN_MINT;
            _view2.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray1;
            break;
        case 3:
            _view2.backgroundColor = XN_COLOR_GREEN_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray2;
            break;
        case 4:
            _view3.backgroundColor = XN_COLOR_GREEN_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray3;
            break;
        case 5:
            _view4.backgroundColor = XN_COLOR_GREEN_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray4;
            break;
        case 6:
            _view5.backgroundColor = XN_COLOR_GREEN_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray5;
            break;
        case 7:
            _view6.backgroundColor = XN_COLOR_GREEN_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            _view7.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray6;
            break;
        case 1:
            _view7.backgroundColor = XN_COLOR_GREEN_MINT;
            _view1.backgroundColor = [UIColor whiteColor];
            _view2.backgroundColor = [UIColor whiteColor];
            _view4.backgroundColor = [UIColor whiteColor];
            _view5.backgroundColor = [UIColor whiteColor];
            _view6.backgroundColor = [UIColor whiteColor];
            _view3.backgroundColor = [UIColor whiteColor];
            weekArray = weekArray7;
            break;
        default:
            break;
    }
    _subscript = sender.tag;
    [_scheduleTab reloadData];
}
/*!
 *  @brief 去除字典空值
 */
- (NSDictionary *)deleteAllNullValue:(NSDictionary *)dic
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dic.allKeys) {
        if ([[dic  objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

// 获取当前是星期几
- (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}
@end
