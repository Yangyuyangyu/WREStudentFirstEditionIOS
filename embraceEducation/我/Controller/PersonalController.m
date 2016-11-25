//
//  PersonalController.m
//  embraceEducation
//
//  Created by waycubeIOSb on 16/5/5.
//  Copyright © 2016年 waycubeIOSXN. All rights reserved.
//

#import "PersonalController.h"
#import "NavigationView.h"
#import <UIImageView+WebCache.h>
#import "ShareSingle.h"
#import "CZCover.h"
#import "CZPopMenu.h"
#import "MySelf.h"

typedef NS_ENUM(NSInteger,ChosePhontType)
{
    
    ChosePhontTypeAlbum,
    ChosePhontTypeCamera
};
@interface PersonalController ()<CZCoverDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>{
    NSArray *sexArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *headpic;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UITextField *familyAddTextField;
//日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//性别
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic , assign)CGFloat lin;

@property (nonatomic, strong)CZCover *cover;
@property (nonatomic, strong)MySelf *myself;

@property (nonatomic, strong)UIDatePicker *datepickView;
@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, assign)BOOL isAmend;
@end

@implementation PersonalController
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NavigationView *navigationView = [[NavigationView alloc] initWithTitle:@"个人信息" leftButtonImage:[UIImage imageNamed:@"back-left.png"]];
    [self.view addSubview:navigationView];
    __weak typeof(self) weakSelf = self;
    navigationView.leftButtonAction = ^(){
        [weakSelf judgeModify];
        if (_isAmend == YES) {
            //提示框
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"您所修改的个人信息并未提交，是否放弃修改。" preferredStyle:UIAlertControllerStyleAlert];
            //添加行为
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _isAmend = NO;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action1];
            [alertController addAction:action];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    _familyAddTextField.delegate = self;
    _nameTextField.delegate = self;
    _lin = _line.constant;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(XN_WIDTH - 64, 37, 60, 15);
    [button setTintColor:[UIColor whiteColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:button];
    NSString *pic = ShareS.head;
    
    _isAmend = NO;
    _headpic.layer.cornerRadius = 30;
    _headpic.layer.masksToBounds = YES;
    [_headpic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing.png"]];
    _nameTextField.placeholder = ShareS.name;
    _phone.text = ShareS.phone;
    _familyAddTextField.placeholder = ShareS.addr;
    _dateLabel.text = ShareS.birthday;
    NSLog(@"%@",ShareS.sex);
    if ([ShareS.sex isEqualToString:@"1"]) {
        _genderLabel.text = @"男";
    }else{
        _genderLabel.text = @"女";
    }
    
    _myself = [[MySelf alloc] init];
    
    sexArray = @[@"男",@"女"];
    
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(imgUpload:) name:@"imgUploadInfokInfoList" object:nil];
    
    //通知传值
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(edit:) name:@"editInfokInfoList" object:nil];
}

- (void)edit:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]) {
        _isAmend = NO;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"修改信息成功" preferredStyle:UIAlertControllerStyleAlert];
        //添加行为
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)imgUpload:(NSNotification *)bitice{
    if ([bitice.userInfo[@"code"] isEqualToNumber:@0]) {
        ShareS.head = bitice.userInfo[@"data"];
        NSString *pic = ShareS.head;
        [_headpic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"beijing.png"]];
        _isAmend = YES;
    }else{
        [self tooltip:@"修改失败"];
    }
}
//右导航按钮
- (void)handleEvent:(UIButton *)sender{
    if (_isAmend == YES) {
        [self modifyInformation];
    }else{
        [self tooltip:@"您并未修改任何信息"];
    }
    
}
- (IBAction)head:(UIButton *)sender {
    [self picture];
}
- (IBAction)gender:(UIButton *)sender {
    [self masking:sender.tag];
}
- (IBAction)date:(UIButton *)sender {
    [self masking:sender.tag];
}
- (void)confirm:(UIButton *)sender{
    if (sender.tag == 2) {
        NSDate *textmydate = [self.datepickView date];
        NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
        [dateformate setDateFormat:@"yyyy-MM-dd"];
        NSString *showdate =[dateformate stringFromDate:textmydate];
        if (![showdate isEqualToString:ShareS.birthday]) {
            _dateLabel.text = showdate;
            ShareS.birthday = showdate;
            _isAmend = YES;
        }
    }else{
        NSInteger showRow = [_pickerView selectedRowInComponent:0];
        NSString *gender = [sexArray objectAtIndex:showRow];
        if (![gender isEqualToString:_genderLabel.text]) {
            _genderLabel.text = gender;
            if ([_genderLabel.text isEqualToString:@"男"]) {
                ShareS.sex = @"1";
            }else{
                ShareS.sex = @"2";
            }
            _isAmend = YES;
        }
    }
    
    [_cover remove];
}

#pragma mark--CZCoverDelegate, UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return sexArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [sexArray objectAtIndex:row];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        _line.constant = -offset;
    }
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    double duration = 0.30f;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        _line.constant = _lin;
    }];
}


//点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark--自定义方法
//提示框
- (void)tooltip:(NSString *)string {
    //提示框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:string preferredStyle:UIAlertControllerStyleAlert];
    //添加行为
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)masking:(NSInteger)number{
    [self.view endEditing:YES];
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
    button.frame = CGRectMake(5, CGRectGetMaxY(self.datepickView.frame)+3, XN_WIDTH - 30, 35);
    button.backgroundColor =XN_COLOR_GREEN_MINT;
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.tag = number;
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    if (number == 2) {
        [view addSubview:self.datepickView];
    }else if (number == 1){
        [view addSubview:self.pickerView];
    }
    [view addSubview:button];
    menu.contentView = view;
    
}
// 点击蒙板的时候调用
- (void)coverDidClickCover:(CZCover *)cover
{
    // 隐藏pop菜单
    [CZPopMenu hide];
    
}

//修改头像
- (void)picture {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择相片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chosePhoto:ChosePhontTypeAlbum];
    }];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chosePhoto:ChosePhontTypeCamera];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:album];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
        self.hidesBottomBarWhenPushed = YES;
        
    }];
    
}

//选择照片
- (void)chosePhoto:(ChosePhontType)type
{
    UIImagePickerController * piker = [[UIImagePickerController alloc]init];
    piker.allowsEditing = YES;
//    piker.showsCameraControls = YES;
    piker.delegate = self;
    
    if (type == ChosePhontTypeAlbum) {
        piker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else if(type == ChosePhontTypeCamera)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            piker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else
        {
            [self tooltip:@"相机不可用"];
            return;
        }
    }
    [self presentViewController:piker animated:YES completion:^{
        self.hidesBottomBarWhenPushed = YES;
    }];
    
    
}

#pragma mark - 选择图片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _headpic.image = info[UIImagePickerControllerOriginalImage];
    NSData * imgData = nil;
    
    if (UIImagePNGRepresentation(_headpic.image)) {
        imgData = UIImagePNGRepresentation(_headpic.image);
    }else if (UIImageJPEGRepresentation(_headpic.image, 1))
    {
        imgData = UIImageJPEGRepresentation(_headpic.image, 1);
    }
    
    //压缩处理
    imgData = UIImageJPEGRepresentation(_headpic.image, 0.00001);
    
    //将图片尺寸变小
    UIImage * theImg = [self zipImageWithData:imgData limitedWith:140];
    [self saveImage:theImg WithName:@"userAvatar"];
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
    
    
    
}

//压缩处理
- (UIImage *)zipImageWithData:(NSData *)imgData limitedWith:(CGFloat)width
{
    //获取图片
    UIImage * img = [UIImage imageWithData:imgData];
    
    CGSize oldImgSize = img.size;
    
    if (width > oldImgSize.width) {
        width = oldImgSize.width;
    }
    
    CGFloat newHeight = oldImgSize.height *((CGFloat)width / oldImgSize.width);
    
    //创建新的图片大小
    CGSize size = CGSizeMake(width, newHeight);
    
    //开启一个图片句柄
    UIGraphicsBeginImageContext(size);
    
    //将图片画入新的size
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //将图片句柄中获取一张新的图片
    UIImage * newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图片句柄
    UIGraphicsEndImageContext();
    
    return newImg;
}

//保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName {
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* totalPath = [documentPath stringByAppendingPathComponent:imageName];
    
    //保存到 document
    [imageData writeToFile:totalPath atomically:NO];
    
    //保存到 NSUserDefaults
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:totalPath forKey:@"avatar"];
    //    NSString *string = [userDefaults objectForKey:@"avatar"];
    //    _usericon.image = [UIImage imageWithContentsOfFile:string];
    //上传头像
    [_myself imgUploadInfokInfoList:imageData];
}
#pragma mark--修改信息
- (void)modifyInformation{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uId"];
    NSString *name = @"";
    if (_nameTextField.text.length == 0) {
        name = ShareS.name;
    }else{
        name = _nameTextField.text;
    }
    NSString *home = @"";
    if (_familyAddTextField.text.length == 0) {
        home = ShareS.addr;
    }else{
        home = _familyAddTextField.text;
    }
    [_myself editInfokInfoList:uid head_img:ShareS.head name:name sex:ShareS.sex birthday:ShareS.birthday home:home];
}
//判断修改
- (void)judgeModify{
    if (_nameTextField.text.length != 0 || _familyAddTextField.text.length != 0) {
        _isAmend = YES;
    }
}




- (UIDatePicker *)datepickView{
    if (!_datepickView) {
        CGFloat popW = XN_WIDTH - 20;
        CGFloat popH = XN_HEIGHT/3 - 45;
        _datepickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, popW, popH)];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        _datepickView.locale = locale;
        _datepickView.datePickerMode = UIDatePickerModeDate;
    }
    return _datepickView;
}
- (UIPickerView *)pickerView{
    if (!_pickerView) {
        CGFloat popW = XN_WIDTH - 20;
        CGFloat popH = XN_HEIGHT/3 - 45;
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, popW, popH)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
@end
