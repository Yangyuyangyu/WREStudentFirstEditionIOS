//
//  ManageController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/3.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ManageController.h"
#import "NavigationView.h"
#import "Organization.h"

@interface ManageController ()<UIWebViewDelegate>{
    NSDictionary *ruleDictionary;
}
@property (weak, nonatomic) IBOutlet UILabel *titel;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIWebView *content;
@property (nonatomic, assign)float height;

@property (nonatomic, strong)Organization *organization;

@end

@implementation ManageController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(rule:) name:@"ruleInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"社团管理制度" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _content.layer.cornerRadius = 10;
    _content.layer.masksToBounds = YES;
    _content.delegate = self;
//    _content.scalesPageToFit = YES;
    _organization = [[Organization alloc] init];
    [_organization ruleInfoList:_gid];
    
    ruleDictionary = [NSDictionary dictionary];
}
- (void)rule:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        _time.hidden = NO;
        _titel.hidden = NO;
        _content.hidden = NO;
        ruleDictionary = bitice.userInfo[@"data"];
        _titel.text = ruleDictionary[@"title"];
        _time.text = ruleDictionary[@"time"];
        NSString *html = ruleDictionary[@"detail"];
        [_content loadHTMLString:html baseURL:nil];
        _height = [[_content stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//        NSLog(@"%f",_height);
    }else{
        _time.hidden = YES;
        _titel.hidden = YES;
        _content.hidden = YES;
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
        label.text = @"还没有社团制度哦";
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
    }
    
}

@end
