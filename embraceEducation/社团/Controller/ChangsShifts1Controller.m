//
//  ChangsShifts1Controller.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/4/29.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "ChangsShifts1Controller.h"
#import "NavigationView.h"
#import "Course.h"
#import "CZCover.h"
#import "CZPopMenu.h"

@interface ChangsShifts1Controller ()<CZCoverDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UITextViewDelegate>{
    NSArray *dataSouce;
    NSMutableArray *nameArray;
    NSMutableArray *idArray;
    NSArray *getSubjectArray;
}
//科目
@property (weak, nonatomic) IBOutlet UILabel *subjects;
//社团
@property (weak, nonatomic) IBOutlet UILabel *community;
//内容
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (nonatomic, strong)Course *course;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic, strong)UIPickerView *pickView;
@property (nonatomic, strong)CZCover *cover;
//社团id
@property (nonatomic, copy)NSString *subjectId;

@property (nonatomic, copy)NSString *communityId;

@property (nonatomic, assign)BOOL isCommunity;
@end

@implementation ChangsShifts1Controller
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(allGroup:) name:@"allGroupInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSubject:) name:@"getSubjectInfoList" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeClass:) name:@"changeClassInfoList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"申请换班" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    navigationView.leftButtonAction = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
    _placeholder.enabled = NO;//lable必须设置为不可用
    _placeholder.backgroundColor = [UIColor clearColor];
    _content.delegate = self;
    _isCommunity = NO;
    dataSouce = [NSArray array];
    nameArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    getSubjectArray = [NSArray array];
    _course = [[Course alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 60, 30, 50, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    int offset = 0;
    if (XN_WIDTH == 320) {
        offset = _backView.frame.size.height - keyboardRect.size.height + 140;//键盘高度216
    }else{
        offset = _backView.frame.size.height - keyboardRect.size.height + 100;//键盘高度216
    }
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        _line.constant = -offset;
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:animationDuration animations:^{
        _line.constant = 64;
    }];
}




- (void)changeClass:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        //提示框
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"提交换班申请成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)getSubject:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        getSubjectArray = bitice.userInfo[@"data"];
        [idArray removeAllObjects];
        [nameArray removeAllObjects];
        for (int i = 0; i < getSubjectArray.count; i ++) {
            [idArray addObject:getSubjectArray[i][@"id"]];
            [nameArray addObject:getSubjectArray[i][@"name"]];
        }
        [_pickView reloadAllComponents];
        [self masking];
    }
}

- (void)allGroup:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]){
        dataSouce = bitice.userInfo[@"data"];
        [idArray removeAllObjects];
        [nameArray removeAllObjects];
        for (int i = 0; i < dataSouce.count; i ++) {
            [nameArray addObject:dataSouce[i][@"name"]];
            [idArray addObject:dataSouce[i][@"id"]];
        }
        [_pickView reloadAllComponents];
        [self masking];
    }
}

- (void)masking{
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

//社团按钮
- (IBAction)community:(UIButton *)sender {
    [_course allGroupInfoList:_gid];
}
//科目按钮
- (IBAction)subjects:(UIButton *)sender {
    if (_subjectId.length == 0) {
        [self tooltip:@"请先选择社团"];
    }else{
        [_course getSubjectInfoList:_subjectId];
    }
    
}
- (void)confirm:(UIButton *)sender{
    NSInteger showRow = [_pickView selectedRowInComponent:0];
    if (_isCommunity == NO) {
        _subjectId = [idArray objectAtIndex:showRow];
        _community.text = [nameArray objectAtIndex:showRow];
        _subjects.text = nil;
        _communityId = nil;
        _isCommunity = YES;
    }else{
        _communityId = [idArray objectAtIndex:showRow];
        _subjects.text = [nameArray objectAtIndex:showRow];
        _isCommunity = NO;
    }
    [_cover remove];
    
    
}

// 点击蒙板的时候调用
- (void)coverDidClickCover:(CZCover *)cover
{
    // 隐藏pop菜单
    [CZPopMenu hide];
    
}
//提交按钮
- (void)handleEvent:(UIButton *)sender{
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uId"];
    if (_subjectId.length == 0) {
        [self tooltip:@"请选择社团"];
    }else if (_communityId.length == 0){
        [self tooltip:@"请选择科目"];
    }else if (_content.text.length == 0){
        [self tooltip:@"请输入换班原因"];
    }else{
        [_course changeClassInfoList:_subjectId student:uid subjectId:_communityId reason:_content.text from:_fromid];
    }
    
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
#pragma mark--CZCoverDelegate, UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return nameArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [nameArray objectAtIndex:row];
}
#pragma mark--UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];//当前的输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        _placeholder.text = @"";
        //        如果输入有中文，且没有出现文字备选框就对字数统计和限制
        //        出现了备选框就暂不统计
        UITextRange *range = [textView markedTextRange];
        
        UITextPosition *position = [textView positionFromPosition:range.start offset:0];
        if (!position)
        {
            
            [self checkText:textView];
            
        }
    }
    else
    {
        [self checkText:textView];
    }
}

- (void)checkText:(UITextView *)textView{
    self.content.text =  textView.text;
    if (textView.text.length == 0) {
        _placeholder.text = @"请输入换班的原因...";
    }else{
        _placeholder.text = @"";
    }
}


#pragma mark--getter

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

//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
