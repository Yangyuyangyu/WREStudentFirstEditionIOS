//
//  PrecedenceController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/4.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "PrecedenceController.h"
#import "NavigationView.h"
#import "RrecedenceCell.h"
#import "KACircleProgressView.h"
#import "Ranking.h"
#import <UIImageView+WebCache.h>
#import "Ranking2Controller.h"
#import "ShareSingle.h"

static NSString *identify = @"RrecedenceCell";
@interface PrecedenceController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *dataSource;
    NSDictionary *dataDic;
    NSArray *myArray;;
}
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
//排名
@property (weak, nonatomic) IBOutlet UILabel *preced;
//评分
@property (weak, nonatomic) IBOutlet UILabel *grade;
//榜
@property (weak, nonatomic) IBOutlet UILabel *list;

@property (weak, nonatomic) IBOutlet UITableView *rankingListTab;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong)Ranking *ranking;

@end

@implementation PrecedenceController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(score:) name:@"scoreInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupRank:) name:@"groupRankInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets =NO;
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:_group leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _list.layer.borderWidth = 1;
    _list.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    _list.layer.cornerRadius = 5;
    _list.layer.masksToBounds = YES;
    _rankingListTab.tableHeaderView = _backView;
    [_rankingListTab setSeparatorInset:UIEdgeInsetsMake(0,66,0,0)];
    _rankingListTab.dataSource = self;
    _rankingListTab.delegate = self;
    
    _ranking = [[Ranking alloc]init];
    dataSource = [NSArray array];
    dataDic = [NSDictionary dictionary];
    if (_groupId.length != 0) {
        [_ranking groupRankInfoList:_groupId];
    }else{
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
        myArray = [NSArray array];
        [_ranking scoreInfoList:_courseId studentId:uid];
    }
    
}
- (void)score:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataDic = bitice.userInfo[@"data"][@"course"];
        dataSource = bitice.userInfo[@"data"][@"rank"];
        myArray = bitice.userInfo[@"data"][@"my"];
        if (myArray.count != 0) {
            NSString *pic = myArray[0][@"head"];
            [_headPic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
            NSNumber *order = myArray[0][@"order"];
            _preced.text = [NSString stringWithFormat:@"第  %@  名",order];
            _grade.text = [NSString stringWithFormat:@"%@分",myArray[0][@"score"]];
        }
        
        _headPic.layer.cornerRadius = 30;
        _headPic.layer.masksToBounds = YES;
        [_rankingListTab reloadData];
    }
}
- (void)groupRank:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataDic = bitice.userInfo[@"data"][@"mine"];
        dataSource = bitice.userInfo[@"data"][@"list"];
        NSString *pic = dataDic[@"head"];
        _headPic.layer.cornerRadius = 30;
        _headPic.layer.masksToBounds = YES;
        [_headPic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
        _preced.text = [NSString stringWithFormat:@"第  %@  名",dataDic[@"order"]];
        _grade.text = [NSString stringWithFormat:@"%@分",dataDic[@"score"]];
        [_rankingListTab reloadData];
    }
}
#pragma mark--UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_groupId.length != 0) {
        return 0;
    }else{
        if (section == 0  && myArray.count != 0) {
            return 8;
        }else{
            return 0;
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    return customView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_groupId.length == 0 && myArray.count != 0) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return dataSource.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RrecedenceCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RrecedenceCell" owner:self options:nil]lastObject];
    }
    
    KACircleProgressView *progress = [[KACircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    [cell.round addSubview:progress];
    progress.trackColor = [UIColor colorWithWhite:0.859 alpha:1.000];
    progress.progressColor = XN_COLOR_GREEN_MINT;
    
    cell.pic.layer.cornerRadius = 25;
    cell.pic.layer.masksToBounds = YES;
    
    if (_groupId.length != 0) {
        NSDictionary *dic = dataSource[indexPath.row];
        NSString *pic = dic[@"head"];
        cell.titel.text = dic[@"name"];
        NSNumber *score = dic[@"score"];
        cell.ranking.text = [NSString stringWithFormat:@"第  %@  名",dic[@"my_order"]];
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
        cell.score.text = [NSString stringWithFormat:@"%.1f分",score.floatValue];
        progress.progress = score.floatValue / 5;
        
    }else{
        if (indexPath.section == 0) {
            if (myArray.count != 0) {
                NSString *pic = myArray[0][@"head"];
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
                NSNumber *order = myArray[0][@"order"];
                cell.titel.text = ShareS.name;
                NSNumber *score = myArray[0][@"score"];
                cell.ranking.text = [NSString stringWithFormat:@"第  %@  名",order];
                cell.score.text = [NSString stringWithFormat:@"%.1f分",score.floatValue];
                progress.progress = score.floatValue / 5;
            }
            
        }else{
            NSDictionary *dic = dataSource[indexPath.row];
            NSString *pic = dic[@"head_img"];
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
            cell.titel.text = dic[@"sname"];
            cell.ranking.text = [NSString stringWithFormat:@"第  %@  名",dic[@"my_order"]];
            NSNumber *score = dic[@"score"];
            cell.score.text = [NSString stringWithFormat:@"%.1f分",score.floatValue];
            progress.progress = score.floatValue / 5;
        }
        
    }
    if (_groupId.length == 0) {
        _rankingListTab.contentSize=CGSizeMake(0, 75 * dataSource.count + _backView.bounds.size.height + 85);
        
    }else{
        _rankingListTab.contentSize=CGSizeMake(0, 75 * dataSource.count + _backView.bounds.size.height);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        Ranking2Controller *precedVC = [[Ranking2Controller alloc] init];
        precedVC.courseId = _courseId;
        [self.navigationController pushViewController:precedVC animated:YES];
    }
}

/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}




@end
