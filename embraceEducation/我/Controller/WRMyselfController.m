//
//  WRMyselfController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "WRMyselfController.h"
#import "MessageController.h"
#import "FriendController.h"
#import "SetController.h"
#import "PersonalController.h"
#import "MySelf.h"
#import <UIImageView+WebCache.h>
#import "ShareSingle.h"
#import "ClassRecordController.h"

@interface WRMyselfController (){
    NSDictionary *dataDic;
}

@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *message;

@property (nonatomic, strong)MySelf *mySelf;

@end

@implementation WRMyselfController
//移除通知
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    [_mySelf studentInfoList:uid];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _message.layer.cornerRadius = 10;
    _message.layer.masksToBounds = YES;
    _message.hidden = YES;
    
    _headPic.layer.cornerRadius = 30;
    _headPic.layer.masksToBounds = YES;
    
    _mySelf = [[MySelf alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(student:) name:@"studentInfoList" object:nil];
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
        NSString *pic = ShareS.head;
        [_headPic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"head3x.png"]];
        _name.text = ShareS.name;
        _phone.text = ShareS.phone;
        _message.text = ShareS.num;
    }
}
//消息中心
- (IBAction)messageCenter:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    MessageController *messageVC = [[MessageController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//邀请好友
- (IBAction)inviteFriends:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FriendController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"FriendController"];
    [self.navigationController pushViewController:appendVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
//设置
- (IBAction)setUp:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    SetController *setVC = [[SetController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//点击头像
- (IBAction)headPic:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"PersonalController"];
    [self.navigationController pushViewController:appendVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//上课记录
- (IBAction)classRecord:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.translucent = false;
    ClassRecordController *classVc = [[ClassRecordController alloc] init];
    classVc.isgroup = NO;
    [self.navigationController pushViewController:classVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
