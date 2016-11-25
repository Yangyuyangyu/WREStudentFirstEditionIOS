//
//  MassController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/29.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "MassController.h"
#import "NavigationView.h"
#import "Organization.h"
#import <UIImageView+WebCache.h>

@interface MassController ()<UIWebViewDelegate>{
    NSDictionary *dataDic;
}

@property (nonatomic, strong)Organization *organization;
@property (nonatomic, strong)NavigationView *navigationView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *time;
//社团按钮
@property (weak, nonatomic) IBOutlet UIButton *mass;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *pic;
//内容
@property (nonatomic, strong)UIWebView *content;
//头视图
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UITableView *headtable;

@property (nonatomic, assign)CGFloat height;
@end

@implementation MassController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newsDetail:) name:@"newsDetailInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"社团名字" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _navigationView = navigationView;
    _organization = [[Organization alloc] init];
    dataDic = [NSDictionary dictionary];
    [_organization newsDetailInfoList:_ID];
    
}

- (void)newsDetail:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSDictionary *dic = bitice.userInfo[@"data"];
        dataDic = [self deleteAllNullValue:dic];
        _titel.text = dataDic[@"name"];
        _navigationView.titleLabel.text = _titel.text;
        [_navigationView.titleLabel sizeToFit];
        _navigationView.titleLabel.center = CGPointMake(XN_WIDTH/2, 45);
        _time.text = dataDic[@"time"];
        [_mass setTitle:dataDic[@"group_name"] forState:UIControlStateNormal];
        [_mass sizeToFit];
        NSString *pic = dataDic[@"img"];
        [_pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
        NSString *str = dataDic[@"detail"];
        [_headtable addSubview:self.content];
        NSString * htmlcontent = [NSString stringWithFormat:@"<style>img{max-width: 100%@;height: auto;}</style>%@",@"%",str];
        [_content loadHTMLString:htmlcontent baseURL:nil];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    _content.frame = CGRectMake(0, 240, _headtable.bounds.size.width, clientheight + 20);
    _headtable.contentSize=CGSizeMake(64, clientheight + _headView.bounds.size.height - 64);

}


- (IBAction)mass:(UIButton *)sender {
    NSLog(@"fgf");
}
/*!
 *  @brief 去除字典空值
 */
- (NSDictionary *)deleteAllNullValue:(NSDictionary *)dic
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dic.allKeys) {
        if ([[dic  objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}


- (UIWebView *)content{
    if (!_content) {
        _content = [[UIWebView alloc] init];
        _content.backgroundColor = [UIColor redColor];
        _content.scrollView.scrollEnabled = NO;
        _content.scalesPageToFit = YES;
        _content.delegate = self;
        [_content sizeToFit];
        _content.scrollView.bounces = NO;
    }
    return _content;
}
@end
