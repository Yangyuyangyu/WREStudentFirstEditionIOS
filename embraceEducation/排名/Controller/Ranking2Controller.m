//
//  Ranking2Controller.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "Ranking2Controller.h"
#import "NavigationView.h"
#import "Rank2Cell.h"
#import "Ranking.h"

static NSString *identify = @"Rank2Cell";
@interface Ranking2Controller ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *rankTab;

@property (nonatomic, strong)Ranking *ranking;

@end

@implementation Ranking2Controller
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myScore:) name:@"myScoreInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"我的排名" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    _ranking = [[Ranking alloc] init];
    dataSource = [NSArray array];
    
    [self.view addSubview:self.rankTab];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    [_ranking myScoreInfoList:_courseId studentId:uid];
    
}


- (void)myScore:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_rankTab reloadData];
    }

}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Rank2Cell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"Rank2Cell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    cell.contentLabel.text = dic[@"name"];
    cell.scoreLabel.text = dic[@"score"];
    return cell;
}


- (UITableView *)rankTab{
    if (!_rankTab) {
        _rankTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT)];
        _rankTab.backgroundColor = [UIColor clearColor];
        _rankTab.tableFooterView = [[UIView alloc] init];
        _rankTab.dataSource = self;
        _rankTab.delegate = self;
        _rankTab.rowHeight = 58;
    }
    return _rankTab;
}




@end
