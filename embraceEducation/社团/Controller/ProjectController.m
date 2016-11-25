//
//  ProjectController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/3.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ProjectController.h"
#import "NavigationView.h"
#import "Course.h"

@interface ProjectController ()<UIWebViewDelegate>

@property (nonatomic, strong)Course *course;

@property (weak, nonatomic) IBOutlet UIWebView *content;

@property (nonatomic, copy)NSString *html;
@end

@implementation ProjectController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(coursePlan:) name:@"coursePlanInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"课程规划" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _course = [[Course alloc] init];
    
    [_course coursePlanInfoList:_gid];
    _content.delegate = self;
    _content.layer.cornerRadius = 10;
    _content.layer.masksToBounds = YES;
    
}
- (void)coursePlan:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _html = bitice.userInfo[@"data"][@"plan"];
        [_content loadHTMLString:_html baseURL:nil];
    }
}


@end
