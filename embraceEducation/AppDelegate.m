//
//  AppDelegate.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/27.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AppDelegate.h"
#import "TabViewController.h"
#import "WRLoginrController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "BPush.h"
#import "MessageController.h"
//#import "KeychainItemWrapper.h"
#import "MySelf.h"
#import "NetworkingManager.h"

static BOOL isBackGroundActivateApplication;
@interface AppDelegate (){
    TabViewController *_tabBarCtr;
}
@property (nonatomic, strong)MySelf *myself;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //    请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"zrcVYFv1KPgotMeDGRtGsxSHj3nhUUFQ"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    _myself = [[MySelf alloc] init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor blackColor];
    [self.window makeKeyAndVisible];
    NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
    if ([defailts objectForKey:@"uId"]) {
        _tabBarCtr = [[TabViewController alloc] init];
        self.window.rootViewController = _tabBarCtr;
    }else{
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WRLoginrController *loginVC = [mainSB instantiateViewControllerWithIdentifier:@"WRLoginrController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBarHidden = YES;
        self.window.rootViewController = nav;
    }
    
    
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    
    [BPush registerChannel:launchOptions apiKey:@"zrcVYFv1KPgotMeDGRtGsxSHj3nhUUFQ" pushMode:BPushModeDevelopment withFirstAction:@"打开" withSecondAction:@"回复" withCategory:@"test" useBehaviorTextInput:YES isDebug:YES];
    
    // 禁用地理位置推送 需要再绑定接口前调用。
    
    [BPush disableLbs];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
    
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    /*
     // 测试本地通知
     [self performSelector:@selector(testLocalNotifi) withObject:nil afterDelay:1.0];
     */
    return YES;
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"acitve ");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveRemoteNotification" object:nil];
        NSLog(@"applacation is unactive ===== %@",userInfo);

    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    NSLog(@"%@",userInfo);
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);

//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    NSString *deviceToken1 = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *deviceToken1 = [BPush getChannelId];
    NSLog(@"%@",deviceToken1);
    
    NSUserDefaults *defailts = [NSUserDefaults standardUserDefaults];
    
    [defailts setObject:deviceToken forKey:@"deviceToken"];
    if (deviceToken1.length == 0) {
        [defailts setObject:@"" forKey:@"deviceToken1"];
    }else{
        [defailts setObject:deviceToken1 forKey:@"deviceToken1"];
    }
    
    
    if ([defailts objectForKey:@"uId"]) {
        [BPush registerDeviceToken:deviceToken];
        NSString *urlstr=[NSString stringWithFormat:@"%@/Api/StudentApi/createTag",Basicurl];
        NSDictionary *dic = @{@"id":[defailts objectForKey:@"uId"],@"channelId":deviceToken1};
        NSLog(@"%@",dic);
        [NetworkingManager sendPOSTRequesWithURL:urlstr parameters:dic successBlock:^(id object) {
            NSLog(@"创建百度推送标签成功%@",object);
            
            [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
                // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
                
                // 网络错误
                if (error) {
                    return ;
                }
                if (result) {
                    // 确认绑定成功
                    if ([result[@"error_code"]intValue]!=0) {
                        return;
                    }
                    // 获取channel_id
                    NSString *myChannel_id = [BPush getChannelId];
                    NSLog(@"==%@",myChannel_id);
                    //获取当前设备应用的tag列表
                    [BPush listTagsWithCompleteHandler:^(id result, NSError *error) {
                        if (result) {
                            NSLog(@"result ============== %@",result);
                        }
                    }];
                    [BPush setTag:deviceToken1 withCompleteHandler:^(id result, NSError *error) {
                        if (result) {
                            NSLog(@"设置tag成功");
                        }
                    }];
                }
            }];
        } failureBlock:^(id object) {
            NSLog(@"创建百度推送标签失败%@",object);
        }];
    }
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    NSLog(@"********** ios7.0之前 **********");
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveRemoteNotification" object:nil];
    }
    
    NSLog(@"%@",userInfo);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {

       [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveRemoteNotification" object:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
