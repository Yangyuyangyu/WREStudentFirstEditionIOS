//
//  ClassRecordController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/19.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ClassRecordController.h"
#import "GivingCell.h"
#import "NavigationView.h"
#import <UIImageView+WebCache.h>
#import "Course.h"
#import <MJRefresh.h>
#import "DetailsController.h"
#import "ClassSituationController.h"
#import "CourseController.h"

static NSString *identify1 = @"GivingCell";
@interface ClassRecordController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *infoArray;
    NSMutableArray *dataSource;
}
@property (nonatomic, strong)UITableView *recorTab;
@property (nonatomic, strong)Course *course;
//页数
@property (nonatomic, copy)NSString *page;

@property (nonatomic, assign)NSInteger count1;//计算页数
@property (nonatomic, copy)NSString *num;//页数
@end

@implementation ClassRecordController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupClass:) name:@"groupClassInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedClass:) name:@"finishedClassInfoList" object:nil];
    if (infoArray.count == 0) {
        if (_isgroup == YES) {
            [_course groupClassInfoList:_groupId page:@"0"];
        }else{
            [_course finishedClassInfoList];
            _recorTab.mj_footer.hidden = YES;
        }
    }
    
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"上课记录" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    NSLog(@"%@",_groupId);
    _count1 = 0;
    _num = @"0";
    infoArray = [NSArray array];
    dataSource = [NSMutableArray array];
    _course = [[Course alloc] init];
    
    [self.view addSubview:self.recorTab];
    
    _recorTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dataSource = [NSMutableArray array];
            if (_isgroup == YES) {
                [_course groupClassInfoList:_groupId page:@"0"];
                _count1 = 0;
            }else{
                [_course finishedClassInfoList];
            }
            [_recorTab.mj_header endRefreshing];//结束刷新
        });
    }];
    //上拉刷新
    _recorTab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_course groupClassInfoList:_groupId page:_num];
            [_recorTab.mj_footer endRefreshing];//结束刷新
            
        });
    }];
    if (_isgroup == YES) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(XN_WIDTH - 95, 30, 100, 30);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:@"社团详情" forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }else{
        _recorTab.mj_footer.hidden = YES;
    }
    
}
//课程
- (void)finishedClass:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        infoArray = bitice.userInfo[@"data"];
        if (infoArray.count != 0) {
            [dataSource addObjectsFromArray:infoArray];
        }
        [_recorTab reloadData];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        _recorTab.hidden = YES;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 75, XN_WIDTH - 30, XN_HEIGHT/4)];
        view.layer.cornerRadius = 10;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        [self.view addSubview:view];
        
        UIImageView *imge = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        imge.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
        imge.image = [UIImage imageNamed:@"weijiaru.png"];
        [view addSubview:imge];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
        label.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetMaxY(imge.frame) + 15);
        label.text = @"还没有上课记录哦";
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
    }

}
//机构
- (void)groupClass:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        infoArray = bitice.userInfo[@"data"];
        if (infoArray.count != 0) {
            [dataSource addObjectsFromArray:infoArray];
            _count1 ++;
            _num = [NSString stringWithFormat:@"%ld",(long)_count1];
            if (infoArray.count < 10) {
                _recorTab.mj_footer.hidden = YES;
            }else{
                _recorTab.mj_footer.hidden = NO;
            }
        }
        [_recorTab reloadData];
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        if (_count1 > 0) {
            _count1 --;
            _num = [NSString stringWithFormat:@"%ld",(long)_count1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示⚠️" message:@"已经是所有内容" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            _recorTab.mj_footer.hidden = YES;
        }else{
            _recorTab.hidden = YES;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 75, XN_WIDTH - 30, XN_HEIGHT/4)];
            view.layer.cornerRadius = 10;
            view.backgroundColor = [UIColor whiteColor];
            view.layer.masksToBounds = YES;
            [self.view addSubview:view];
            
            UIImageView *imge = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            imge.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetHeight(view.frame)/2);
            imge.image = [UIImage imageNamed:@"weijiaru.png"];
            [view addSubview:imge];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
            label.center = CGPointMake(CGRectGetWidth(view.frame)/2, CGRectGetMaxY(imge.frame) + 15);
            label.text = @"还没有上课记录哦";
            label.font = [UIFont systemFontOfSize:14];
            [view addSubview:label];
        }
        
    }
}

- (void)handleEvent:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    DetailsController * forgetVC = [[DetailsController alloc] init];
    forgetVC.gid = _groupId;
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)evaluationButton:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.translucent = false;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClassSituationController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"ClassSituationController"];
    appendVC.courseId = dataSource[sender.tag][@"id"];
    appendVC.type = dataSource[sender.tag][@"type"];
    [self.navigationController pushViewController:appendVC animated:YES];
}

#pragma mark--UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GivingCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GivingCell" owner:self options:nil]lastObject];
    }
    cell.sign.hidden = YES;
    cell.reportView.hidden = YES;
    NSDictionary *dic = dataSource[indexPath.row];
    NSString *pic = dic[@"img"];
    [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing.png"]];
    cell.time.text = dic[@"class_time"];
    cell.week.text = dic[@"name"];

    NSString *type = dic[@"type"];
//    NSInteger status = [dic[@"status"]integerValue];
    if ([type isEqualToString:@"1"]) {
        cell.big.text = @"(大课)";
    }else{
        cell.big.text = @"(小课)";
    }
    [cell.evaluationButton setTitle:@"查看课程报告" forState:UIControlStateNormal];
    cell.evaluationButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cell.evaluationButton setTintColor:XN_COLOR_GREEN_MINT];
    cell.evaluationButton.layer.borderWidth = 1;
    cell.evaluationButton.layer.borderColor = XN_COLOR_GREEN_MINT.CGColor;
    cell.evaluationButton.layer.cornerRadius = 5;
    cell.evaluationButton.layer.masksToBounds = YES;
    cell.evaluationButton.tag = indexPath.row;
    [cell.evaluationButton addTarget:self action:@selector(evaluationButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.evaluationLine.constant = 100;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 102;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CourseController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"CourseController"];
    appendVC.courseId = infoArray[indexPath.row][@"cid"];
    [self.navigationController pushViewController:appendVC animated:YES];
}
#pragma mark--getter
- (UITableView *)recorTab{
    if (!_recorTab) {
        _recorTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _recorTab.tableFooterView = [[UIView alloc] init];
        _recorTab.dataSource = self;
        _recorTab.delegate = self;
    }
    return _recorTab;
}

@end
