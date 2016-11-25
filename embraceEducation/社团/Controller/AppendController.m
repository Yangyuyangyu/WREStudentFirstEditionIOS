//
//  AppendController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/28.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "AppendController.h"
#import "WROrganizCell.h"
#import "DetailsController.h"
#import "Organization.h"
#import "AppendCell.h"
#import <UIImageView+WebCache.h>
#import "CZCover.h"
#import "WREducationController.h"

static NSString *identify = @"WROrganizCell";
static NSString *identify1 = @"AppendCell";
static NSString *identify2 = @"CELL";
@interface AppendController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CZCoverDelegate>{
    NSArray *infoArray;
    NSArray *projectArray;
}
//搜索图片
@property (weak, nonatomic) IBOutlet UIImageView *electPic;
//搜索
@property (weak, nonatomic) IBOutlet UITextField *seek;

@property (weak, nonatomic) IBOutlet UITableView *seekTableView;//主

@property (nonatomic, strong)UITableView *projectTab;
//位置
@property (weak, nonatomic) IBOutlet UILabel *place;
//选项
@property (weak, nonatomic) IBOutlet UILabel *option;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong)Organization *organization;

@property (nonatomic, assign)BOOL recommended;

@property (nonatomic, strong)CZCover *cover;

@property (nonatomic, assign)NSInteger number;
@end

@implementation AppendController

//移除通知
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _recommended = NO;
    _number = 3;
    _option.text = @"社团";
    _seek.text = nil;
    [_organization groupInfoList1:@"0"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    让分割线顶头
    if ([self.projectTab respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.projectTab setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.projectTab respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.projectTab setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    _organization = [[Organization alloc] init];
    _seekTableView.dataSource = self;
    _seekTableView.delegate = self;
    _seek.clearButtonMode = UITextFieldViewModeAlways;
    _seek.autocorrectionType = UITextAutocorrectionTypeNo;
    _seek.returnKeyType = UIReturnKeySearch;
    _seek.delegate = self;
    _seekTableView.rowHeight = 120;
    _seekTableView.tableFooterView = [[UIView alloc] init];
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    _backView.layer.borderWidth = 1;
    _backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    projectArray = @[@"机构",@"学校",@"社团"];
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(group:) name:@"groupInfoList" object:nil];
}



- (void)group:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0] || [bitice.userInfo[@"code"] isEqualToNumber:@(-1)]){
        infoArray = bitice.userInfo[@"data"][@"list"];
        if (infoArray.count == 0) {
            [self tooltip:@"没有搜索到相关内容"];
        }else{
            [_seekTableView reloadData];
        }
    }
    
}

//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark--UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 3;
    }else{
         return infoArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        cell.textLabel.text = projectArray[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (_number == 3) {
            WROrganizCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"WROrganizCell" owner:self options:nil]lastObject];
            }
            [cell.contentPic sd_setImageWithURL:[NSURL URLWithString:infoArray[indexPath.row][@"img"]] placeholderImage:[UIImage imageNamed:@"topbackground.png"]];
            cell.titel.text = infoArray[indexPath.row][@"name"];
            cell.intro.text = infoArray[indexPath.row][@"brief"];
            cell.teacher.text = infoArray[indexPath.row][@"admin_name"];
            cell.auditPic.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            AppendCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"AppendCell" owner:self options:nil]lastObject];
            }
            NSString *pic = infoArray[indexPath.row][@"img"];
            [cell.pic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"topbackground.png"]];
            cell.titel.text = infoArray[indexPath.row][@"name"];
            cell.teacher.text = infoArray[indexPath.row][@"userNum"];
            cell.location.text = infoArray[indexPath.row][@"location"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}
/*设置标题头的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        return 0;
    }else{
        if (_recommended == NO) {
            return 40;
        }else{
            return 0;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] init];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor colorWithWhite:0.255 alpha:1.000];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.frame = CGRectMake(20, 0.0, 300.0, 44.0);
    UILabel * Label = [[UILabel alloc] initWithFrame:CGRectZero];
    Label.backgroundColor = XN_COLOR_GREEN_MINT;
    Label.frame = CGRectMake(15, 12, 2, 20);
    [customView addSubview:Label];
    headerLabel.text =  @"为你推荐";
    [customView addSubview:headerLabel];
    
    return customView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        _number = indexPath.row + 1;
        _option.text = projectArray[_number - 1];
        NSString *str = [NSString stringWithFormat:@"%ld",_number];
        [_organization groupInfoList1:str];
        _recommended = NO;
        [_cover remove];
    }else{
        if (_number != 3) {
            self.hidesBottomBarWhenPushed = YES;
            UIStoryboard * mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WREducationController * educationVC = [mainSB instantiateViewControllerWithIdentifier:@"WREducationController"];
            educationVC.gid = infoArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:educationVC animated:YES];
        }else{
            self.hidesBottomBarWhenPushed = YES;
            DetailsController *detailsVC = [[DetailsController alloc] init];
            detailsVC.gid = infoArray[indexPath.row][@"id"];
            [self.navigationController pushViewController:detailsVC animated:YES];
        }
    }
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *str = [NSString stringWithFormat:@"%d",_number];
    [_organization groupInfoList:str name:_seek.text];
    _recommended = YES;
    [_seek resignFirstResponder];
    return YES;
}

#pragma mark--按钮点击事件
//定位
- (IBAction)location:(UIButton *)sender {
    NSLog(@"定位");
    
}
//选择搜索
- (IBAction)elect:(UIButton *)sender {
    // 弹出蒙板
    _cover = [CZCover show];
    _cover.delegate = self;
    [self.view addSubview:_cover];
    [_cover addSubview:self.projectTab];
}
//取消
- (IBAction)abolish:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark--getter
- (UITableView *)projectTab{
    if (!_projectTab) {
        _projectTab = [[UITableView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_backView.frame) + 64, 100, 90)];
        _projectTab.tableFooterView = [[UIView alloc] init];
        _projectTab.dataSource = self;
        _projectTab.delegate = self;
        [_projectTab setSeparatorInset:UIEdgeInsetsMake(0,-60,0,0)];
        _projectTab.rowHeight = 30;
        _projectTab.scrollEnabled = NO;
        _projectTab.tag = 100;
    }
    return _projectTab;
}
@end
