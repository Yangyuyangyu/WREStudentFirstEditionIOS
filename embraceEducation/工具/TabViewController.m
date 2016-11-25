//
//  TabViewController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "TabViewController.h"
#import "WROrganizationController.h"
#import "WRRankingController.h"
#import "WRMyselfController.h"
#import "WRSyllabusController.h"
#import "MessageController.h"

@interface TabViewController ()

@end

@implementation TabViewController
//移除通知
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化控制器
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.tabBarController.tabBar.translucent = false;
    WRMyselfController * MyVc = [mainSB instantiateViewControllerWithIdentifier:@"WRMyselfController"];
    WROrganizationController *OrganizationVc = [mainSB instantiateViewControllerWithIdentifier:@"WROrganizationController"];
    WRRankingController *RankingVc = [mainSB instantiateViewControllerWithIdentifier:@"WRRankingController"];
    WRSyllabusController *SyllabusVc = [mainSB instantiateViewControllerWithIdentifier:@"WRSyllabusController"];
    
    // 1.初始化子控制器
    [self addChildVc:OrganizationVc title:@"社团" image:@"shouye-1@3x.png" selectedImage:@"shetuan@3x.png"];
    
    [self addChildVc:SyllabusVc title:@"课程表" image:@"kechengbiao@3x.png" selectedImage:@"kechengbiao3@3x.png"];
    
    [self addChildVc:RankingVc title:@"排名" image:@"paiming@3x.png" selectedImage:@"paiming2@3x.png"];
    
    [self addChildVc:MyVc title:@"我" image:@"wo3@3x.png" selectedImage:@"wo@3x.png"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveRemote) name:@"didReceiveRemoteNotification" object:nil];
}

- (void)didReceiveRemote{
    MessageController *skipCtr = [[MessageController alloc]init];
    [self.selectedViewController pushViewController:skipCtr animated:YES];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = XN_COLOR_GREEN_MINT;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    childVc.view.backgroundColor = [UIColor whiteColor];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBarHidden = YES;
    // 添加为子控制器
    [self addChildViewController:nav];
}

@end
