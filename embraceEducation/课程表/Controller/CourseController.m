//
//  CourseController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/3.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "CourseController.h"
#import "NavigationView.h"
#import "InstructionsCell.h"
#import "DetailsCell.h"
#import "EvaluationCell.h"
#import "WREducationController.h"
#import "Course.h"
#import "CZCover.h"
#import "AskleaveCell.h"
#import "AskLeaveController.h"
#import "ComplaintsController.h"
#import <UIImageView+WebCache.h>

static NSString *identify = @"InstructionsCell";
static NSString *identify1 = @"DetailsCell";
static NSString *identify2 = @"EvaluationCell";
static NSString *identify3 = @"AskleaveCell";
@interface CourseController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,CZCoverDelegate>{
    NSDictionary *dataDic;
    NSDictionary *teacherInfoDic;
    NSArray *infoArray;
    NSArray *commentArray;
    NSArray *askArray;
}
@property (nonatomic, strong)Course *course;
@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)NavigationView *navigationView;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *bigpic;

@property (weak, nonatomic) IBOutlet UILabel *titel;
@property (weak, nonatomic) IBOutlet UILabel *content;
//所属机构
@property (weak, nonatomic) IBOutlet UILabel *institutions;
//地址
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
//特点
@property (weak, nonatomic) IBOutlet UILabel *characteristics;

@property (weak, nonatomic) IBOutlet UIButton *cDescription;
@property (weak, nonatomic) IBOutlet UIView *cldescription;

@property (weak, nonatomic) IBOutlet UIButton *details;
@property (weak, nonatomic) IBOutlet UIView *dldetails;

@property (weak, nonatomic) IBOutlet UIButton *evaluation;
@property (weak, nonatomic) IBOutlet UIView *elevaluation;
@property (weak, nonatomic) IBOutlet UITableView *messageTab;


@property(nonatomic, assign)BOOL choice1;
@property(nonatomic, assign)BOOL choice2;
@property(nonatomic, assign)BOOL choice3;

@property (nonatomic, assign)CGFloat height;

//弹出Tab
@property (nonatomic, strong)UITableView *czTabel;
@end

@implementation CourseController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(course:) name:@"courseInfoInfoList" object:nil];
    [_course courseInfoInfoList:_courseId Id:_Id];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _choice1 = YES;
    _choice2 = NO;
    _choice3 = NO;
    _cldescription.backgroundColor = XN_COLOR_GREEN_MINT;
    __weak typeof(self) weakSelf = self;
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"课程详情" leftButtonImage:[UIImage imageNamed:@"back-left.png"] rightButtonImage:[UIImage imageNamed:@"point.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    navigationView.rightButtonAction = ^(){
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = weakSelf;
        [weakSelf.view addSubview:_cover];
        [_cover addSubview:weakSelf.czTabel];
    };
    _navigationView = navigationView;
    
    //    让分割线顶头
    if ([self.czTabel respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.czTabel setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.czTabel respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.czTabel setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    
    
    _course = [[Course alloc] init];

    self.messageTab.tableHeaderView = self.backView;
    self.messageTab.dataSource = self;
    self.messageTab.delegate = self;
    dataDic = [NSDictionary dictionary];
    teacherInfoDic = [NSDictionary dictionary];
    commentArray = [NSArray array];
    infoArray = @[@"适学人群",@"教学目标",@"退班规则",@"插班规则"];
    askArray = @[@"请假",@"投诉"];
    
    
}

- (void)course:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataDic = bitice.userInfo[@"data"];
        teacherInfoDic = [self deleteAllNullValue:dataDic[@"teacherInfo"]];
        commentArray = dataDic[@"commentList"];
        NSString *pic = dataDic[@"img"];
        [_bigpic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
        _titel.text = dataDic[@"name"];
        _navigationView.titleLabel.text = dataDic[@"name"];
        [_navigationView.titleLabel sizeToFit];
        _navigationView.titleLabel.center = CGPointMake(XN_WIDTH/2, 45);
        _content.text = dataDic[@"brief"];
        _institutions.text = dataDic[@"agency"];
        NSNumber *type = dataDic[@"type"];
        NSString *typeStr = type.description;
        if ([typeStr isEqualToString:@"1"]) {
            _address.text = dataDic[@"address"];
        }
        
        NSString *headPic = teacherInfoDic[@"head"];
        [_pic sd_setImageWithURL:[NSURL URLWithString:headPic] placeholderImage:[UIImage imageNamed:@"head2x.png"]];
        _name.text = teacherInfoDic[@"name"];
        _characteristics.text = teacherInfoDic[@"label_admin"];
        [_messageTab reloadData];
    }
}
#pragma mark--UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return askArray.count;
    }else{
        if (_choice1 == YES) {
            return infoArray.count;
        }else if (_choice2 == YES){
            return 1;
        }else{
            if (commentArray.count == 0) {
                return 1;
            }else{
                return commentArray.count;
            }
        }
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        AskleaveCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AskleaveCell" owner:self options:nil]lastObject];
        }
        cell.content.text = askArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.pic.image = [UIImage imageNamed:@"leave.png"];
        }else{
            cell.pic.image = [UIImage imageNamed:@"complaints.png"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (_choice1 == YES) {
            InstructionsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"InstructionsCell" owner:self options:nil]lastObject];
            }
            cell.titel.text = infoArray[indexPath.row];
            if (indexPath.row == 0) {
                cell.content.text = dataDic[@"fit_crowd"];
            }else if (indexPath.row == 1){
                cell.content.text = dataDic[@"goal"];
            }else if (indexPath.row == 2){
                cell.content.text = dataDic[@"quit_rule"];
            }else if (indexPath.row == 3){
                cell.content.text = dataDic[@"join_rule"];
            }
            _messageTab.contentSize=CGSizeMake(0, 70 * 4 + _backView.bounds.size.height);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (_choice2 == YES){
            DetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailsCell" owner:self options:nil]lastObject];
            }
            NSString *html = dataDic[@"detail"];
            NSString * htmlcontent = [NSString stringWithFormat:@"<style>img{max-width: 100%@;height: auto;}</style>%@",@"%",html];
            cell.content.scrollView.scrollEnabled = NO;
            cell.content.delegate = self;
            [cell.content sizeToFit];
            cell.content.scrollView.bounces = NO;
            [cell.content loadHTMLString:htmlcontent baseURL:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            EvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationCell" owner:self options:nil]lastObject];
            }
            
            if (commentArray.count == 0) {
               _messageTab.contentSize=CGSizeMake(0, _backView.bounds.size.height + 50);
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
                label.center = CGPointMake(XN_WIDTH/2, cell.frame.size.height/2 - 30);
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"暂无评价";
                [cell.contentView addSubview:label];
            }else{
                NSDictionary *dic = commentArray[indexPath.row];
                NSString *pic = dic[@"head"];
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"head2x.png"]];
                cell.name.text = dic[@"name"];
                cell.date.text = dic[@"time"];
                cell.content.text = dic[@"content"];
                _messageTab.contentSize=CGSizeMake(0, 109 * commentArray.count + _backView.bounds.size.height);
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    }
    
}

//让分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100) {
        return 30;
    }else{
        if (_choice1 == YES) {
            return 70;
        }else if (_choice2 == YES){
            return _height;
        }else{
            return 109;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (indexPath.row == 0) {
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            AskLeaveController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"AskLeaveController"];
            appendVC.courseId = _courseId;
            [self.navigationController pushViewController:appendVC animated:YES];
        }else{
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ComplaintsController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"ComplaintsController"];
            appendVC.teacherId = teacherInfoDic[@"id"];
            appendVC.name = teacherInfoDic[@"name"];
            [self.navigationController pushViewController:appendVC animated:YES];
        }
        [_cover remove];
    }else{
    
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取页面高度（像素）
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    _height = clientheight;
    webView.frame = CGRectMake(0, 0, XN_WIDTH, clientheight + 20);
    _messageTab.contentSize=CGSizeMake(64, clientheight + _backView.bounds.size.height + 20);
    
    
}

#pragma mark--按钮点击事件
//机构
- (IBAction)institution:(UIButton *)sender {
    NSString *gid = dataDic[@"agency_id"];
    UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WREducationController * appendVC = [mainSB instantiateViewControllerWithIdentifier:@"WREducationController"];
    appendVC.gid = gid;
    [self.navigationController pushViewController:appendVC animated:YES];
}

//信息
- (IBAction)subsection:(UIButton *)sender {
    if (sender.tag == 0) {
        _choice1 = YES;
        _choice2 = NO;
        _choice3 = NO;
        _cldescription.backgroundColor = XN_COLOR_GREEN_MINT;
        _elevaluation.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        _dldetails.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        [_messageTab reloadData];
    }else if (sender.tag == 1){
        _choice1 = NO;
        _choice2 = YES;
        _choice3 = NO;
        _dldetails.backgroundColor = XN_COLOR_GREEN_MINT;
        _elevaluation.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        _cldescription.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        [_messageTab reloadData];

    }else{
        _choice1 = NO;
        _choice2 = NO;
        _choice3 = YES;
        _elevaluation.backgroundColor = XN_COLOR_GREEN_MINT;
        _cldescription.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        _dldetails.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
        [_messageTab reloadData];
    }
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


#pragma mark--getter
- (UITableView *)czTabel{
    if (!_czTabel) {
        _czTabel = [[UITableView alloc]initWithFrame:CGRectMake(XN_WIDTH - 120, 64, 100, 60)];
        _czTabel.tableFooterView = [[UIView alloc] init];
        _czTabel.dataSource = self;
        _czTabel.delegate = self;
        _czTabel.scrollEnabled = NO;
        _czTabel.tag = 100;
    }
    return _czTabel;
}


@end
