//
//  MessageController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/4.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "MessageController.h"
#import "NavigationView.h"
#import "MessageCell.h"
#import "MySelf.h"
#import <MJRefresh.h>

static NSString *identify = @"MessageCell";
@interface MessageController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *dataSource;
}
@property (nonatomic, strong)UITableView *messageTab;
@property (nonatomic, strong)MySelf *myself;

@end

@implementation MessageController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(message:) name:@"messageInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"消息" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.messageTab];
    _myself = [[MySelf alloc] init];
    dataSource = [NSArray array];
    [_myself messageInfoList];
    
    
    _messageTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_myself messageInfoList];
            [_messageTab.mj_header endRefreshing];//结束刷新
        });
    }];
}

- (void)message:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSource = bitice.userInfo[@"data"];
        [_messageTab reloadData];
    }
}
#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = dataSource[indexPath.row];
    cell.pic.layer.cornerRadius = 19;
    cell.pic.layer.masksToBounds = YES;
    
    cell.titel.text = @"系统提示";
    cell.content.text = dic[@"content"];
    cell.time.text = dic[@"time"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableView *)messageTab{
    if (!_messageTab) {
        _messageTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 64)];
        _messageTab.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
        _messageTab.tableFooterView = [[UIView alloc] init];
        _messageTab.dataSource = self;
        _messageTab.delegate = self;
    }
    return _messageTab;
}

@end
