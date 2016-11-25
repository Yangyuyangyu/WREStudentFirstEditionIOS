//
//  WREducationController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/29.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "WREducationController.h"
#import "homepageCell.h"
#import "WROrganizCell.h"
#import "DetailsController.h"
#import "Organization.h"
#import <UIImageView+WebCache.h>
#import "MapViewController.h"

static NSString *identify1 = @"homepageCell";
static NSString *identify2 = @"WROrganizCell";
@interface WREducationController ()<UITableViewDataSource, UITableViewDelegate>{
    NSArray *dataSource;
    NSDictionary *dataSourceDic;
}
//头像按钮

@property (weak, nonatomic) IBOutlet UIImageView *headPic;

//机构名称
@property (weak, nonatomic) IBOutlet UILabel *institution;
//主页线
@property (weak, nonatomic) IBOutlet UIView *homel;
//机构线
@property (weak, nonatomic) IBOutlet UIView *institutions;
//简介
//@property (weak, nonatomic) IBOutlet UILabel *intro;
//消息条数
@property (nonatomic, assign)BOOL choose;
@property (weak, nonatomic) IBOutlet UITableView *infoTabel;

@property (nonatomic, strong)Organization *organization;
@property (nonatomic, assign)CGRect rect;
@end

@implementation WREducationController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(agencyDetail:) name:@"agencyDetailInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _choose = NO;
    _homel.backgroundColor = XN_COLOR_GREEN_MINT;
    _infoTabel.delegate = self;
    _infoTabel.tableFooterView = [[UIView alloc] init];
    _infoTabel.dataSource = self;
    _infoTabel.scrollEnabled = NO;
    _organization = [[Organization alloc] init];
    [_organization agencyDetailInfoList:_gid];
    _headPic.layer.cornerRadius = 30;
    _headPic.layer.masksToBounds = YES;
    dataSource = [NSArray array];
    dataSourceDic = [NSDictionary dictionary];
    
}
- (void)agencyDetail:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSourceDic = bitice.userInfo[@"data"];
        dataSource = dataSourceDic[@"groups"];
        NSString *headPic = dataSourceDic[@"img"];
        [_headPic sd_setImageWithURL:[NSURL URLWithString:headPic]];
        _institution.text = dataSourceDic[@"name"];
//        _intro.text = dataSourceDic[@"brief"];
        [_infoTabel reloadData];
    }
}
#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_choose == NO) {
        return 3;
    }else{
        return dataSource.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_choose == NO) {
        homepageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"homepageCell" owner:self options:nil]lastObject];
        }
        if (indexPath.row == 0) {
            cell.name.text = @"简介:";
            cell.content.text = dataSourceDic[@"brief"];
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            _rect = [cell.content.text boundingRectWithSize:CGSizeMake(XN_WIDTH - 30, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        }else if (indexPath.row == 1){
            cell.name.text = @"理念:";
            cell.content.text = dataSourceDic[@"feature"];
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            _rect = [cell.content.text boundingRectWithSize:CGSizeMake(XN_WIDTH - 30, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
        }else if (indexPath.row == 2){
            cell.name.text = @"位置:";
            cell.content.text = dataSourceDic[@"location"];
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
            _rect = [cell.content.text boundingRectWithSize:CGSizeMake(XN_WIDTH - 30, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        WROrganizCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"WROrganizCell" owner:self options:nil]lastObject];
        }
        NSString *pic = dataSource[indexPath.row][@"img"];
        [cell.contentPic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"head2x.png"]];
        cell.titel.text = dataSource[indexPath.row][@"name"];
        cell.teacher.text = dataSource[indexPath.row][@"admins"];
        cell.intro.text = dataSource[indexPath.row][@"brief"];
        cell.auditPic.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_choose == YES) {
        DetailsController * forgetVC = [[DetailsController alloc] init];
        forgetVC.gid = dataSource[indexPath.row][@"id"];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }else{
        if (indexPath.row == 1) {
            MapViewController *mapVc = [[MapViewController alloc] init];
            mapVc.loati = dataSourceDic[@"latitude"];
            mapVc.longi = dataSourceDic[@"longitude"];
            [self.navigationController pushViewController:mapVc animated:YES];
        }
    }
    
}

/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_choose == NO) {
        return _rect.size.height + 20;
    }else{
        return 120;
    }
}


//返回按钮
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//切换主页
- (IBAction)homepage:(UIButton *)sender {
    _choose = NO;
    _homel.backgroundColor = XN_COLOR_GREEN_MINT;
    _institutions.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
    _infoTabel.scrollEnabled = NO;
    [_infoTabel reloadData];
}
//切换机构
- (IBAction)institutionButton:(UIButton *)sender {
    _choose = YES;
    _institutions.backgroundColor = XN_COLOR_GREEN_MINT;
    _homel.backgroundColor = [UIColor colorWithWhite:0.949 alpha:1.000];
    _infoTabel.scrollEnabled = YES;
    [_infoTabel reloadData];
}
@end
