//
//  ClassSituationController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ClassSituationController.h"
#import "SubmitJobController.h"
#import "PrecedenceController.h"
#import "NavigationView.h"
#import "CourseCell.h"

#import "ClassS.h"

#import "MJExtension.h"
#import <UIImageView+WebCache.h>

#import "ClassFrame.h"
#import "Course.h"

static NSString *identify = @"CourseCell";
@interface ClassSituationController ()<UITableViewDataSource, UITableViewDelegate>{
    NSDictionary *dataDic;
    NSMutableArray *mutDataArray;
    NSMutableArray *mutDataFrameArray;
    NSArray *imageArray;
    NSArray *labelArray;
}
@property (weak, nonatomic) IBOutlet UIView *banckView;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitLine;

@property (weak, nonatomic) IBOutlet UIButton *ranking;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankingLine;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)Course *course;

@property (nonatomic, strong)NavigationView *navigationView;

/**
 *  ViewModel:CZStatusFrame
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation ClassSituationController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(courseReport:) name:@"courseReportInfoList" object:nil];
    
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"课程报告" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _navigationView = navigationView;
    NSLog(@"%@",_courseId);
    if ([_type isEqualToString:@"2"]) {
        _ranking.hidden = YES;
        _submitLine.constant = 0;
    }else{
        _ranking.layer.borderWidth = 1;
        _ranking.layer.borderColor = [UIColor colorWithWhite:0.906 alpha:1.000].CGColor;
        _ranking.layer.cornerRadius = 5;
        _ranking.layer.masksToBounds = YES;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _course = [[Course alloc] init];
    dataDic = [NSDictionary dictionary];
    mutDataFrameArray = [NSMutableArray array];
    mutDataArray = [NSMutableArray array];
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    [_course courseReportInfoList:_courseId studentId:uid];
    
    imageArray = @[[UIImage imageNamed:@"content2x.png"],[UIImage imageNamed:@"situation2x.png"],[UIImage imageNamed:@"Way2x.png"],[UIImage imageNamed:@"homework2x.png"]];
    labelArray = @[@"课堂内容",@"上课情况及问题",@"解决办法",@"课后作业"];
}
- (void)courseReport:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataDic = bitice.userInfo[@"data"];
        _navigationView.titleLabel.text = dataDic[@"name"];
        [_navigationView.titleLabel sizeToFit];
        _navigationView.titleLabel.center = CGPointMake(XN_WIDTH/2, 45);
        NSString *has_work = dataDic[@"has_work"];
        if ([has_work isEqualToString:@"0"]) {
            _submit.hidden = YES;
            _rankingLine.constant = 0;
        }else{
            _submit.layer.borderWidth = 1;
            _submit.layer.borderColor = [UIColor colorWithWhite:0.906 alpha:1.000].CGColor;
            _submit.layer.cornerRadius = 5;
            _submit.layer.masksToBounds = YES;
        }
        NSString *content = dataDic[@"content"];
        NSString *problem = dataDic[@"problem"];
        NSString *solution = dataDic[@"solution"];
        NSString *work_content = dataDic[@"work_content"];
        NSString *pic = dataDic[@"img"];
        NSArray *arr = @[];
        NSArray *array=nil;
        if ([pic containsString:@","]) {
            //            NSLog(@"包含,");
            array = [pic componentsSeparatedByString:@","];
            
            
        } else {
            //            NSLog(@"不存在,");
            array=@[pic];
        }
        
        NSMutableDictionary *mutDic1 = [NSMutableDictionary dictionary];
        [mutDic1 setObject:content forKey:@"text"];
        [mutDic1 setObject:arr forKey:@"pic_urls"];
        
        NSMutableDictionary *mutDic2 = [NSMutableDictionary dictionary];
        [mutDic2 setObject:problem forKey:@"text"];
        [mutDic2 setObject:arr forKey:@"pic_urls"];
        
        NSMutableDictionary *mutDic3 = [NSMutableDictionary dictionary];
        [mutDic3 setObject:solution forKey:@"text"];
        [mutDic3 setObject:arr forKey:@"pic_urls"];
        
        NSMutableDictionary *mutDic4 = [NSMutableDictionary dictionary];
        [mutDic4 setObject:work_content forKey:@"text"];
        NSMutableDictionary *pic0 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic1 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic2 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic3 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic4 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic5 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic6 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic7 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic8 = [NSMutableDictionary dictionary];
        NSMutableDictionary *pic9 = [NSMutableDictionary dictionary];
        NSArray *add = @[pic0,pic1,pic2,pic3,pic4,pic5,pic6,pic7,pic8,pic9];
        NSMutableArray *mArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i ++) {
            NSString *str = array[i];
           
            if(str!=nil&&![str isEqualToString:@""]){
                 NSLog(@"作业图片%@",str);
                [add[i] setObject:str forKey:@"pic"];
                [mArray addObject:add[i]];
            }
            
        }
        [mutDic4 setObject:mArray forKey:@"pic_urls"];
        
        NSMutableArray *mutArray = [NSMutableArray array];
        [mutArray addObject:mutDic1];
        [mutArray addObject:mutDic2];
        [mutArray addObject:mutDic3];
        [mutArray addObject:mutDic4];
        NSArray *statuses = (NSMutableArray *)[ClassS objectArrayWithKeyValuesArray:mutArray];
        NSMutableArray *statusFrames = [NSMutableArray array];
        for (ClassS *classS in statuses) {
            ClassFrame *classF = [[ClassFrame alloc] init];
            classF.classS = classS;
            [statusFrames addObject:classF];
        }
        [mutDataArray addObjectsFromArray:statusFrames];
        [_tableView reloadData];
    }else {
        _banckView.hidden = YES;
        _tableView.hidden = YES;
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
        label.text = @"还没有课程报告哦";
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
    }
}

#pragma mark--UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return mutDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 35;
    }else{
        return 0;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.831 alpha:1.000];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithWhite:0.255 alpha:1.000];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.frame = CGRectMake(15, 8, 300.0, 21.0);
    headerLabel.text =  dataDic[@"class_time"];
    [customView addSubview:headerLabel];
    
    return customView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseCell *cell = [CourseCell cellWithTableView:tableView];
    ClassFrame *classF = mutDataArray[indexPath.section];
    cell.classFrame = classF;
    if (indexPath.section == 2) {
        cell.toolBar.imageView.width = 18;
    }
    cell.toolBar.imageView.image = imageArray[indexPath.section];
    cell.toolBar.label.text = labelArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    return customView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassFrame *classF = mutDataArray[indexPath.section];
    return classF.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark--按钮点击事件
//我的排名
- (IBAction)ranking:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PrecedenceController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"PrecedenceController"];
    appendVC.courseId = dataDic[@"class_id"];
    appendVC.groupId = @"";
    appendVC.group = dataDic[@"name"];
    [self.navigationController pushViewController:appendVC animated:YES];
    
}
//提交作业
- (IBAction)submit:(UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SubmitJobController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"SubmitJobController"];
    appendVC.courseId = _courseId;
    appendVC.titel = _navigationView.titleLabel.text;
    [self.navigationController pushViewController:appendVC animated:YES];
}


- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}
@end
