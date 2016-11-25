//
//  change shifts change shifts ChangeShiftsController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/29.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ChangeShiftsController.h"
#import "NavigationView.h"
#import "ChangCell.h"
#import "Course.h"
#import <UIImageView+WebCache.h>
#import "ChangsShifts1Controller.h"

static NSString *indentiy = @"ChangCell";
@interface ChangeShiftsController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSouce;
}
@property (nonatomic, strong)UITableView *subjectsTab;
@property (nonatomic, strong)Course *course;
@end

@implementation ChangeShiftsController
//移除通知
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    [_course mySubjectInfoList:_gid sid:uid];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"申请换班" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _course = [[Course alloc] init];
    
    [self.view addSubview:self.subjectsTab];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mySubject:) name:@"mySubjectInfoList" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)mySubject:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSouce = bitice.userInfo[@"data"];
        [_subjectsTab reloadData];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        [self tooltip:@"暂时没有数据"];
    }
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangCell *cell = [tableView dequeueReusableCellWithIdentifier:indentiy];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChangCell" owner:self options:nil]lastObject];
    }
    
    [cell.chang addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    cell.chang.tag = indexPath.row;
    NSString *str = dataSouce[indexPath.row][@"status"];
    if ([str isEqualToString:@"0"]) {
        [cell.chang setTitle:@"正在审核中" forState:UIControlStateNormal];
        [cell.chang setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cell.line.constant = 85;
    }else{
        [cell.chang setTitle:@"换班" forState:UIControlStateNormal];
        cell.chang.layer.borderWidth = 1;
        cell.chang.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
        cell.chang.layer.cornerRadius = 5;
        cell.chang.layer.masksToBounds = YES;
    }
    cell.subjects.text = dataSouce[indexPath.row][@"name"];
    cell.introduction.text = [NSString stringWithFormat:@"简介：%@",dataSouce[indexPath.row][@"intro"]];
    NSString *pic = dataSouce[indexPath.row][@"img"];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark--按钮点击
- (void)handleEvent:(UIButton *)sender{
    NSString *str = dataSouce[sender.tag][@"status"];
    if ([str isEqualToString:@"0"]) {
        [self tooltip:@"正在审核中"];
    }else{
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChangsShifts1Controller * changVc = [mainSB instantiateViewControllerWithIdentifier:@"ChangsShifts1Controller"];
        changVc.gid = _gid;
        changVc.fromid = dataSouce[sender.tag][@"id"];
        [self.navigationController pushViewController:changVc animated:YES];
    }
}

//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark--getter
- (UITableView *)subjectsTab{
    if (!_subjectsTab) {
        _subjectsTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT)];
        _subjectsTab.tableFooterView = [[UIView alloc] init];
        _subjectsTab.dataSource = self;
        _subjectsTab.rowHeight = 100;
        _subjectsTab.delegate = self;
    }
    return _subjectsTab;
}
@end
