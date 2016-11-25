//
//  ConstructionController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/29.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
// 社团建设表

#import "ConstructionController.h"
#import "NavigationView.h"
#import "Detail1Cell.h"
#import "Organization.h"

static NSString *identify1 = @"Detail1Cell";
@interface ConstructionController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *setArray;
    NSDictionary *dataDic;
}
@property (nonatomic, strong)UITableView *chartTabel;
@property (nonatomic, strong)Organization *organization;
@end

@implementation ConstructionController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupBuild:) name:@"groupBuildInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"社团建设表" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.chartTabel];
    _organization = [[Organization alloc] init];
    dataDic = [NSDictionary dictionary];
    setArray = @[@"社团名称:",@"创建时间:",@"学生人数:",@"管理人数:",@"开设科目:"];
    [_organization groupBuildInfoList:_gid];
    
}

- (void)groupBuild:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataDic = bitice.userInfo[@"data"];
        [_chartTabel reloadData];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Detail1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Detail1Cell" owner:self options:nil]lastObject];
    }
    if (indexPath.row == 0) {
        cell.detai.text = dataDic[@"name"];
    }else if (indexPath.row == 1){
        cell.detai.text = dataDic[@"create_time"];
    }else if (indexPath.row == 2){
        cell.detai.text = dataDic[@"studentNum"];
    }else if (indexPath.row == 3){
        cell.detai.text = dataDic[@"adminNum"];
    }else {
        cell.detai.text = dataDic[@"subjectNum"];
    }
    cell.name.text = setArray[indexPath.row];
    return cell;
}



- (UITableView *)chartTabel{
    if (!_chartTabel) {
        _chartTabel = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, 225)];
        _chartTabel.tableFooterView = [[UIView alloc] init];
        _chartTabel.dataSource = self;
        _chartTabel.delegate = self;
        _chartTabel.scrollEnabled =NO; //设置tableview 不能滚动
    }
    return _chartTabel;
}
@end
