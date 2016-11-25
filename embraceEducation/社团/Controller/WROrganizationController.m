//
//  WROrganizationController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "WROrganizationController.h"
#import "WRLoginrController.h"
#import "NavigationView.h"
#import "WROrganizCell.h"
#import "AppendController.h"
#import "DetailsController.h"
#import "Organization.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "MySelf.h"
#import "ShareSingle.h"
#import "ClassRecordController.h"
#import "MySelf.h"

static NSString *identify = @"WROrganizCell";
@interface WROrganizationController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *infoArray;
    NSMutableArray *dataSource;
    NSDictionary *dataDic;
}
@property (nonatomic, strong)UITableView *organizationTableView;
//左按钮
@property (weak, nonatomic) IBOutlet UIButton *left;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titel;
//位置
@property (weak, nonatomic) IBOutlet UILabel *place;
//底部view
@property (weak, nonatomic) IBOutlet UIView *bottonView;
@property (nonatomic, strong)Organization *organization;
@property (nonatomic, copy)NSString *num;//下拉加载参数
@property (nonatomic, assign)NSInteger count;//判断是否有更多数据
@property (nonatomic, assign)NSInteger count1;//存储下拉页数
@property (nonatomic, strong)MySelf *mySelf;

@end

@implementation WROrganizationController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(student:) name:@"studentInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myGroup:) name:@"myGroupInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aboutUs:) name:@"aboutUsInfoList" object:nil];
    if (dataSource.count == 0) {
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
        _count1 = 0;
        dataSource = [NSMutableArray array];
        [_organization myGroupInfoList:uid page:@"0"];
    }
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [NSMutableArray array];
    infoArray = [NSArray array];
    dataDic = [NSDictionary dictionary];
    _organization = [[Organization alloc] init];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    
    _num = @"0";
    
    [self.view addSubview:self.organizationTableView];
    _organizationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dataSource = [NSMutableArray array];
            [_organization myGroupInfoList:uid page:@"0"];
            _count1 = 0;
            [_organizationTableView.mj_header endRefreshing];//结束刷新
        });
    }];
    //上拉刷新
    _organizationTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                [_organization myGroupInfoList:uid page:_num];
                [_organizationTableView.mj_footer endRefreshing];//结束刷新

        });
    }];
    _mySelf = [[MySelf alloc]init];
    [_mySelf studentInfoList:uid];
    [_mySelf aboutUsInfoList];
    
}

- (void)aboutUs:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        ShareS.customerService = bitice.userInfo[@"data"][@"telephone"];
    }
}

- (void)student:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataDic = bitice.userInfo[@"data"];
        ShareS.addr = dataDic[@"addr"];
        ShareS.birthday = dataDic[@"birthday"];
        ShareS.head = dataDic[@"head"];
        ShareS.name = dataDic[@"name"];
        ShareS.password = dataDic[@"password"];
        ShareS.phone = dataDic[@"phone"];
        ShareS.num = dataDic[@"num"];
        ShareS.sex = dataDic[@"sex"];
    }
}

- (void)myGroup:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        infoArray = bitice.userInfo[@"data"];
        if (infoArray.count != 0) {
            _bottonView.hidden = YES;
            _organizationTableView.hidden = NO;
            [dataSource addObjectsFromArray:infoArray];
            _count1 ++;
            _num = [NSString stringWithFormat:@"%ld",(long)_count1];
            if (infoArray.count < 10) {
                _organizationTableView.mj_footer.hidden = YES;
            }else{
                _organizationTableView.mj_footer.hidden = NO;
            }
        }else{
            _bottonView.hidden = NO;
            _organizationTableView.hidden = YES;
        }
        [_organizationTableView reloadData];
        _bottonView.userInteractionEnabled = YES;
    }else if ([bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        if (_count1 > 0) {
            _count1 --;
            _num = [NSString stringWithFormat:@"%ld",(long)_count1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示⚠️" message:@"已经是所有内容" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:NULL];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            _organizationTableView.mj_footer.hidden = YES;
        }else{
            _bottonView.hidden = NO;
            _organizationTableView.hidden = YES;
        }
        
    }
    
}
#pragma mark--UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WROrganizCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WROrganizCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row][@"groupInfo"];
    NSString *pic = dic[@"img"];
    [cell.contentPic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"wing2x.png"]];
    cell.titel.text = dic[@"name"];
    cell.teacher.text = dic[@"admins"];
    cell.intro.text = dic[@"brief"];
    if ([dataSource[indexPath.row][@"status"] isEqualToString:@"1"]) {
        cell.auditPic.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hidesBottomBarWhenPushed = YES;
    ClassRecordController * forgetVC = [[ClassRecordController alloc] init];
    forgetVC.groupId = dataSource[indexPath.row][@"groupInfo"][@"id"];
    forgetVC.isgroup = YES;
    [self.navigationController pushViewController:forgetVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark--按钮点击事件
//添加社团
- (IBAction)add:(UIButton *)sender {
    self.tabBarController.tabBar.translucent = false;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppendController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AppendController"];
    [self.navigationController pushViewController:appendVC animated:YES];
}

- (UITableView *)organizationTableView{
    if (!_organizationTableView) {
        _organizationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 105)];
        _organizationTableView.rowHeight = 120;
        _organizationTableView.tableFooterView = [[UIView alloc] init];
        _organizationTableView.dataSource = self;
        _organizationTableView.delegate = self;
    }
    return _organizationTableView;
}
@end
