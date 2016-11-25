//
//  WRRankingViewController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "WRRankingController.h"
#import "RankingCell.h"
#import "PrecedenceController.h"
#import "Ranking.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

static NSString *identify = @"RankingCell";
@interface WRRankingController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *rankingTab;

@property (nonatomic, strong)Ranking *ranking;

@end

@implementation WRRankingController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rank:) name:@"rankInfoList" object:nil];
    [_ranking rankInfoList];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _rankingTab.delegate = self;
    _rankingTab.dataSource = self;
    _rankingTab.tableFooterView = [[UIView alloc] init];
    _ranking = [[Ranking alloc] init];
    
    dataSource = [NSArray array];
    
    _rankingTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_ranking rankInfoList];
            [_rankingTab.mj_header endRefreshing];//结束刷新
        });
    }];
}

- (void)rank:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_rankingTab reloadData];
    }
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RankingCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *picStr = dic[@"img"];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:picStr] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
    cell.school.text = dic[@"agency"];
    cell.team.text = dic[@"group"];
    cell.number.text = dic[@"order"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PrecedenceController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"PrecedenceController"];
    appendVC.groupId = dataSource[indexPath.row][@"group_id"];
    appendVC.courseId = @"";
    appendVC.group = dataSource[indexPath.row][@"group"];
    [self.navigationController pushViewController:appendVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
@end
