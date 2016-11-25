//
//  SetController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/4.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "SetController.h"
#import "NavigationView.h"
#import "Detai3Cell.h"
#import "ChangePasswordController.h"
#import "FeedbackController.h"
#import "AboutUsController.h"
#import "WRLoginrController.h"
#import <SDImageCache.h>
#import "ShareSingle.h"

static NSString *identiy = @"Detai3Cell";
@interface SetController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *setTab;
@property (nonatomic, strong)NSArray *titelArray;

@property (nonatomic, copy)NSString *tmpSize;

@end

@implementation SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"设置" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.view.backgroundColor = [UIColor colorWithWhite:0.808 alpha:1.000];
    [self.view addSubview:self.setTab];
    _setTab.dataSource = self;
    _setTab.delegate = self;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(15, CGRectGetMaxY(_setTab.frame) + 20, XN_WIDTH - 30, 40);
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:@"退出" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = XN_COLOR_GREEN_MINT;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    _titelArray = @[@"修改密码",@"清理缓存",@"意见反馈",@"客服电话",@"关于我们"];
    
    
}


#pragma 清理缓存图片

- (void)clearTmpPics
{
   

}


#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        Detai3Cell *cell = [tableView dequeueReusableCellWithIdentifier:identiy];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Detai3Cell" owner:self options:nil]lastObject];
        }
        cell.name.text = _titelArray[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        Detai3Cell *cell = [tableView dequeueReusableCellWithIdentifier:identiy];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Detai3Cell" owner:self options:nil]lastObject];
        }
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XN_WIDTH - 145, 12, 120, 21)];
            //计算检查缓存大小
            float tmpSize = [[SDImageCache sharedImageCache] getSize];
            float size = tmpSize / 1024.0 / 1024.0;
            NSString *clearCacheName = size >= 1 ? [NSString stringWithFormat:@"%.2fM",size] : [NSString stringWithFormat:@"%.2fK",size * 1024];
            _tmpSize = clearCacheName;
            label.text = clearCacheName;
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:label];
        }else if (indexPath.row == 2){
            cell.pic.hidden = YES;
            UIImageView *image = [[UIImageView alloc ]initWithFrame:CGRectMake(XN_WIDTH - 70, 12, 20, 20)];
            image.image = [UIImage imageNamed:@"phone2x.png"];
            [cell.contentView addSubview:image];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XN_WIDTH - 70, 12, 60, 21)];
            label.text = @"拨号";
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:label];
        }
        cell.name.text = _titelArray[indexPath.row + 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ChangePasswordController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"ChangePasswordController"];
        [self.navigationController pushViewController:appendVC animated:YES];
    }else{
        switch (indexPath.row) {
            case 0:{
                //提示框
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否清理缓存？" preferredStyle:UIAlertControllerStyleAlert];
                //添加行为
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                //添加行为
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[SDImageCache sharedImageCache] clearDisk];
                    [_setTab reloadData];
                }];
                [alertController addAction:action1];
                [alertController addAction:action];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case 1:{
                self.hidesBottomBarWhenPushed = YES;
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                FeedbackController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"FeedbackController"];
                [self.navigationController pushViewController:appendVC animated:YES];
            }
                break;
            case 2:{
                NSString *phone = ShareS.customerService;
                if (phone.length != 0) {
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
                    UIWebView * callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                }
            }
                break;
            case 3:{
                self.hidesBottomBarWhenPushed = YES;
                UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                AboutUsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AboutUsController"];
                [self.navigationController pushViewController:appendVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

/*设置标题头的名称*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"帐号";
    }else{
        return @"更多";
    }
}


- (void)handleEvent:(UIButton *)sender{
    NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
    [defailts removeObjectForKey:@"uId"];
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WRLoginrController * loginVC = [mainSB instantiateViewControllerWithIdentifier:@"WRLoginrController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    nav.navigationBarHidden = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
}



- (UITableView *)setTab{
    if (!_setTab) {
        _setTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, 275)];
        _setTab.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
        _setTab.tableFooterView = [[UIView alloc] init];
        _setTab.scrollEnabled = NO;
        _setTab.dataSource = self;
        _setTab.delegate = self;
    }
    return _setTab;
}



@end
