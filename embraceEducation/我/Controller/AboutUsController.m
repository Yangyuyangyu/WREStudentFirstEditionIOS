//
//  AboutUsController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AboutUsController.h"
#import "NavigationView.h"
#import "MySelf.h"

@interface AboutUsController ()<UIWebViewDelegate>
@property (nonatomic, strong)MySelf *myself;
@property (weak, nonatomic) IBOutlet UIImageView *headpic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLine;
@property (weak, nonatomic) IBOutlet UIWebView *detailWeb;

@end

@implementation AboutUsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aboutUs:) name:@"aboutUsInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"关于我们" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _versionLabel.text = @"版本：1.0";
    
    _myself = [[MySelf alloc] init];
    [_myself aboutUsInfoList];
    
    
}

- (void)aboutUs:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _phone.text = bitice.userInfo[@"data"][@"telephone"];
        NSString *str = bitice.userInfo[@"data"][@"detail"];
        _detailWeb.scrollView.scrollEnabled = NO;
        _detailWeb.delegate = self;
        [_detailWeb loadHTMLString:str baseURL:nil];
        
    }
}
- (IBAction)phone:(UIButton *)sender {
    if (_phone.text.length != 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phone.text];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else{
        NSLog(@"aaa");
    }
    
}


@end
