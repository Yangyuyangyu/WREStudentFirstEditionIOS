//
//  DetailsController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/29.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "DetailsController.h"
#import "NavigationView.h"
#import "Detail1Cell.h"
#import "Detai2Cell.h"
#import "Detai3Cell.h"
#import "ChangeShiftsController.h"
#import "ProjectController.h"
#import "ConstructionController.h"
#import "ManageController.h"
#import "Organization.h"
#import "Course.h"
#import "CZCover.h"
#import "CZPopMenu.h"
#import "MassController.h"
#import <UIImageView+WebCache.h>


static NSString *identify1 = @"Detail1Cell";
static NSString *identify2 = @"Detai2Cell";
static NSString *identify3 = @"Detai3Cell";
@interface DetailsController ()<UITableViewDataSource, UITableViewDelegate, CZCoverDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray *construction;//建设
    NSArray *dynamic;//动态
    NSDictionary *information;//信息
    NSArray *setArray;
    NSMutableArray *subjects;//科目
    NSMutableArray *subjectsId;//科目id
}
@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)Organization *organization;
@property (nonatomic, strong)Course *course;
@property (nonatomic, strong)UITableView *detailsTable;
@property (nonatomic, strong)UIButton *addOrgan;
@property (nonatomic, strong)UIPickerView *pickView;
@property (nonatomic, assign)CGRect rect;

@property(nonatomic, strong)UITextView *textView;

@property (nonatomic, assign)NSInteger height;
@end

@implementation DetailsController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupDetail:) name:@"groupDetailInfoList" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSubject:) name:@"getSubjectInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(joinGroup:) name:@"joinGroupInfoList" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _height = 140;
    self.view.backgroundColor = [UIColor whiteColor];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"社团详情页" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.view.userInteractionEnabled = YES;
    _addOrgan = [UIButton buttonWithType:UIButtonTypeCustom];
    _addOrgan.frame = CGRectMake(13, XN_HEIGHT - 60, XN_WIDTH - 26, 40);
    _addOrgan.layer.cornerRadius = 5;
    _addOrgan.layer.masksToBounds = YES;
    _addOrgan.backgroundColor = XN_COLOR_GREEN_MINT;
    [_addOrgan setTintColor:[UIColor whiteColor]];
    [_addOrgan setTitle:@"加入社团" forState:UIControlStateNormal];
    [_addOrgan addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addOrgan];
    [self.view addSubview:self.detailsTable];
    
    
    _organization = [[Organization alloc] init];
    _course = [[Course alloc] init];
    setArray = @[@"名       称:",@"简       介:",@"所属学校:",@"管理老师:"];
    construction = @[@"课程规划",@"社团建设",@"管理制度"];
    information = [NSDictionary dictionary];
    dynamic = [NSArray array];
    subjects = [NSMutableArray array];
    subjectsId = [NSMutableArray array];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    [_organization groupDetailInfoList:_gid studentId:uid];
    
    
}
- (void)groupDetail:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        information = bitice.userInfo[@"data"];
        id news = information[@"news"];
        if ([news isEqual:@""]) {
            dynamic = @[];
        }else{
            dynamic = information[@"news"];
        }
        if ([information[@"joined"] isEqualToString:@"-1"]) {
            [_addOrgan setTitle:@"加入社团" forState:UIControlStateNormal];
        }else if ([information[@"joined"] isEqualToString:@"0"]){
           [_addOrgan setTitle:@"正在审核中" forState:UIControlStateNormal];
        }else if ([information[@"joined"] isEqualToString:@"1"]){
            [_addOrgan setTitle:@"申请换班" forState:UIControlStateNormal];
        }else{
            [_addOrgan setTitle:@"再次申请加入社团" forState:UIControlStateNormal];
            _detailsTable.frame = CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - 240);
            _textView.text = information[@"refuse"];
            [self.view addSubview:self.textView];
        }

        [_detailsTable reloadData];
    }
    
}

- (void)getSubject:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSArray *array = bitice.userInfo[@"data"];
        for (int i = 0; i < array.count; i ++) {
            NSString *str = array[i][@"name"];
            NSString *strid = array[i][@"id"];
            [subjects addObject:str];
            [subjectsId addObject:strid];
        }
        // 弹出蒙板
        _cover = [CZCover show];
        _cover.delegate = self;
        [self.view addSubview:_cover];
        // 弹出pop菜单
        CGFloat popW = XN_WIDTH - 20;
        CGFloat popX = 10;
        CGFloat popH = XN_HEIGHT/3;
        CGFloat popY = XN_HEIGHT/3;
        CZPopMenu *menu = [CZPopMenu showInRect:CGRectMake(popX, popY, popW, popH)];
        menu.layer.cornerRadius = 10;
        menu.layer.masksToBounds = YES;
        menu.backgroundColor = [UIColor whiteColor];
        [_cover addSubview:menu];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(popX, popY, popW, popH)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, CGRectGetMaxY(self.pickView.frame)+3, XN_WIDTH - 30, 35);
        button.backgroundColor =XN_COLOR_GREEN_MINT;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTintColor:[UIColor whiteColor]];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:self.pickView];
        [view addSubview:button];
        menu.contentView = view;

    }
}

- (void)joinGroup:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
        [_organization groupDetailInfoList:_gid studentId:uid];
        //提示框
        [self tooltip:@"申请加入社团成功"];
    }
}
#pragma mark--UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        if (dynamic.count == 0) {
            return 1;
        }else{
            return dynamic.count;
        }
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        Detail1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Detail1Cell" owner:self options:nil]lastObject];
        }
        cell.name.text = setArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.detai.text = information[@"name"];
        }else if (indexPath.row == 2){
            cell.detai.text = information[@"agency_name"];
        }else if (indexPath.row == 1){
            
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
            _rect = [information[@"brief"] boundingRectWithSize:CGSizeMake(XN_WIDTH - 30, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributes
                                                      context:nil];
            cell.detai.text = information[@"brief"];
            
        }else{
            cell.detai.text = information[@"admins"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 1){
        if (dynamic.count == 0) {
            static NSString *ident = @"CELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = @"暂未添加";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            Detai2Cell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"Detai2Cell" owner:self options:nil]lastObject];
            }
            NSDictionary *dic = dynamic[indexPath.row];
            cell.titel.text = dic[@"name"];
            cell.detai.text = dic[@"brief"];
            NSString *pic = dic[@"img"];
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing@3x.png"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else {
        Detai3Cell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Detai3Cell" owner:self options:nil]lastObject];
        }
        cell.name.font = [UIFont boldSystemFontOfSize:17];
        cell.name.text = construction[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 35;
    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0;
    }else{
         return 10;
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor colorWithWhite:0.843 alpha:1.000];
    return customView;
}
/*设置标题头的名称*/
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17];
    headerLabel.frame = CGRectMake(15, -5, 300.0, 44.0);
    if (section == 1) {
        headerLabel.text =  @"社团动态";
    }
    [customView addSubview:headerLabel];
    
    return customView;
}
/*设置cell 的宽度 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (dynamic.count == 0) {
            return 35;
        }else{
            return 90;
        }
        
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                return _rect.size.height + 20;
            }else{
                return 35;
            }
        }else{
            return 45;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (dynamic.count != 0) {
            self.hidesBottomBarWhenPushed = YES;
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MassController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"MassController"];
            forgetVC.ID = dynamic[indexPath.row][@"id"];
            [self.navigationController pushViewController:forgetVC animated:YES];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 0) {//课程规划
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProjectController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"ProjectController"];
        forgetVC.gid = information[@"id"];
        [self.navigationController pushViewController:forgetVC animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 1){//社团建设表
        self.hidesBottomBarWhenPushed = YES;
        ConstructionController * forgetVC = [[ConstructionController alloc] init];
        forgetVC.gid = information[@"id"];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 2){
        self.hidesBottomBarWhenPushed = YES;
        UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageController * forgetVC = [mainSB instantiateViewControllerWithIdentifier:@"ManageController"];
        forgetVC.gid = information[@"id"];
        [self.navigationController pushViewController:forgetVC animated:YES];
    }
}

#pragma mark--按钮点击事件
- (void)handleEvent:(UIButton *)sender{
    if ([information[@"joined"] isEqualToString:@"-1"] || [information[@"joined"] isEqualToString:@"2"]) {
        [_course getSubjectInfoList:information[@"id"]];
    }else if ([information[@"joined"] isEqualToString:@"0"]){
        [self tooltip:@"申请正在审核中..."];
    }else if ([information[@"joined"] isEqualToString:@"1"]){
        self.hidesBottomBarWhenPushed = YES;
        ChangeShiftsController *changVc = [[ChangeShiftsController alloc] init];
        changVc.gid = information[@"id"];
        [self.navigationController pushViewController:changVc animated:YES];
    }
    
    
}
- (void)confirm:(UIButton *)sender{
    [_cover remove];
    NSInteger showRow = [_pickView selectedRowInComponent:0];
    NSString *subjectId = [subjectsId objectAtIndex:showRow];
    NSString *titel = [NSString stringWithFormat:@"是否加入%@",information[@"name"]];
    NSString *studentId = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:titel preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        [_organization joinGroupInfoList:information[@"id"] studentId:studentId subjectId:subjectId];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [alertController addAction:action1];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark--CZCoverDelegate, UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return subjects.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [subjects objectAtIndex:row];
}
// 点击蒙板的时候调用
- (void)coverDidClickCover:(CZCover *)cover
{
    // 隐藏pop菜单
    [CZPopMenu hide];
    
}

//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark--getter
- (UITableView *)detailsTable{
    if (!_detailsTable) {
        _detailsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, XN_WIDTH, XN_HEIGHT - _height)];
        _detailsTable.tableFooterView = [[UIView alloc] init];
        _detailsTable.dataSource = self;
        _detailsTable.delegate = self;
    }
    return _detailsTable;
}

- (UIPickerView *)pickView{
    if (!_pickView) {
        CGFloat popW = XN_WIDTH - 20;
        CGFloat popH = XN_HEIGHT/3 - 45;
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, popW, popH)];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, XN_HEIGHT - 170, XN_WIDTH - 30, 100)];
        _textView.editable = NO;
        _textView.textColor = [UIColor redColor];
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView;
}
@end
