//
//  RegisterViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/17.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "RegisterViewController.h"

//views
//#import "HBLockSliderView.h"
#import "STPickerDate.h"
#import "MySlider.h"

//tools
#import "NSString+MD5.h"
#import "UIImage+Orientation.h"
#import <AFNetworking.h>

@interface RegisterViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,STPickerDateDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgPotrait;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfBirthday;
@property (weak, nonatomic) IBOutlet UITextField *tfVerificationCode;
@property (weak, nonatomic) IBOutlet UIButton *btnVerificationCode;
@property (weak, nonatomic) IBOutlet UIView *maleBGView;
@property (weak, nonatomic) IBOutlet UIView *femaleBGView;

//@property (nonatomic, strong)HBLockSliderView *maleSlider;
//@property (nonatomic, strong)HBLockSliderView *femaleSlider;
@property (nonatomic, strong)STPickerDate *datePicker;
@property (nonatomic, strong)MySlider *maleSlider;
@property (nonatomic, strong)MySlider *femaleSlider;
@property (nonatomic, strong)UILabel *labelMale;
@property (nonatomic, strong)UILabel *labelFemale;

@property (nonatomic, strong)NSString *gender;
@property (nonatomic, strong)NSData *imgData;
@property (nonatomic, strong)NSString *birthdayStr;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingOutlets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取注册数据>
-(void)getRegisterData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kRegister];
    
    //md5密码
    NSString *password = [kSalt stringByAppendingString:self.tfPassword.text];
    password = [NSString md5WithInputText:password];
    
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (self.imgData) {
        dictParameter = @{@"mobile":self.tfPhone.text,
                          @"password":password,
                          @"verify_code":self.tfVerificationCode.text,
                          @"birthday":self.birthdayStr,
                          @"sex":self.gender,
                          @"user_img":self.imgData};
    }else{
        dictParameter = @{@"mobile":self.tfPhone.text,
                          @"password":password,
                          @"verify_code":self.tfVerificationCode.text,
                          @"birthday":self.birthdayStr,
                          @"sex":self.gender};
    }
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"multipart/form-data",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json", nil];
    [manager POST:urlStr
       parameters:nil
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFormData:[self.tfPhone.text dataUsingEncoding:NSUTF8StringEncoding] name:@"mobile"];
    [formData appendPartWithFormData:[self.tfVerificationCode.text dataUsingEncoding:NSUTF8StringEncoding] name:@"verify_code"];
    [formData appendPartWithFormData:[password dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
    [formData appendPartWithFormData:[self.birthdayStr dataUsingEncoding:NSUTF8StringEncoding] name:@"birthday"];
    [formData appendPartWithFormData:[self.gender dataUsingEncoding:NSUTF8StringEncoding] name:@"sex"];
    
    if (self.imgData) {
        [formData appendPartWithFileData:self.imgData name:@"user_img" fileName:@"user_img.jpg" mimeType:@"image/jpeg"];
    }
}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (responseObject) {
                  NSDictionary *dataDict = (NSDictionary *)responseObject;
                  NSNumber *code = (NSNumber *)dataDict[@"code"];
                  if ([code isEqual:@200]) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hideAnimated:YES afterDelay:1.0];
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:EIO warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:2.0];
                          hudWarning.completionBlock = ^{
                              [self dismissViewControllerAnimated:YES completion:nil];
                          };
                      });
                  }else{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hideAnimated:YES afterDelay:1.0];
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:EIO warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:2.0];
                      });
                  }
              }else{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [hud hideAnimated:YES afterDelay:1.0];
                      MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:EIO warningMessage:kRequestError];
                      [hudWarning hideAnimated:YES afterDelay:2.0];
                  });
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [hud hideAnimated:YES afterDelay:1.0];
                  MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:EIO warningMessage:kRequestError];
                  [hudWarning hideAnimated:YES afterDelay:2.0];
              });
          }];
    
}

#pragma mark - <获取短信验证数据>
-(void)getSendMsgData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSendMsg];
    NSDictionary *dictParameter = @{@"mobile":self.tfPhone.text};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //开启验证码倒计时
                    [self openBtnVerificationCountDowm];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <验证码按钮倒计时效果>
-(void)openBtnVerificationCountDowm
{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.btnVerificationCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.btnVerificationCode setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateNormal];
                self.btnVerificationCode.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.btnVerificationCode setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.btnVerificationCode setTitleColor:kColorFromRGB(kDeepGray) forState:UIControlStateNormal];
                self.btnVerificationCode.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - <配置outlets>
-(void)settingOutlets
{
    //给头像添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeMyHeadPotrait)];
    self.imgPotrait.userInteractionEnabled = YES;
    [self.imgPotrait addGestureRecognizer:tap];
    
    //tfBirthday添加响应
    self.tfBirthday.delegate = self;
    
//    //添加左滑选择男性
//    self.maleSlider = [[HBLockSliderView alloc]initWithFrame:self.maleBGView.bounds];
//    self.maleSlider.delegate = self;
//    self.maleSlider.value = 1;
//    self.maleSlider.thumbImage = [UIImage imageNamed:@"man"];
//    [self.maleBGView addSubview:self.maleSlider];
    self.maleSlider = [[MySlider alloc]initWithFrame:self.maleBGView.bounds];
    [self.maleSlider trackRectForBounds:self.maleBGView.bounds];
    [self.maleBGView addSubview:self.maleSlider];
    self.maleSlider.minimumValue = 0;
    self.maleSlider.maximumValue = 1;
    self.maleSlider.value = 1;
//    self.maleSlider.continuous = YES;
    
    self.labelMale = [[UILabel alloc]initWithFrame:self.maleBGView.bounds];
    self.labelMale.text = @"<<";
    self.labelMale.font = [UIFont systemFontOfSize:15];
    self.labelMale.textAlignment = NSTextAlignmentCenter;
    self.labelMale.textColor = kColorFromRGB(kWhite);
    self.labelMale.layer.masksToBounds = YES;
    self.labelMale.layer.cornerRadius = self.maleBGView.frame.size.height/2.0;
    [self.maleBGView addSubview:self.labelMale];
    
//    [self.maleSlider setThumbImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [self.maleSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    
    
//    //添加右滑选择女生
//    self.femaleSlider = [[HBLockSliderView alloc]initWithFrame:self.femaleBGView.bounds];
//    self.femaleSlider.delegate = self;
//    self.femaleSlider.thumbImage = [UIImage imageNamed:@"women"];
//    [self.femaleBGView addSubview:self.femaleSlider];
    self.femaleSlider = [[MySlider alloc]initWithFrame:self.femaleBGView.bounds];
    [self.femaleSlider trackRectForBounds:self.femaleBGView.bounds];
    [self.femaleBGView addSubview:self.femaleSlider];
    self.femaleSlider.minimumValue = 0;
    self.femaleSlider.maximumValue = 1;
    self.femaleSlider.value = 0;
    //    self.femaleSlider.continuous = YES;
    
    self.labelFemale = [[UILabel alloc]initWithFrame:self.maleBGView.bounds];
    self.labelFemale.text = @">>";
    self.labelFemale.font = [UIFont systemFontOfSize:15];
    self.labelFemale.textAlignment = NSTextAlignmentCenter;
    self.labelFemale.textColor = kColorFromRGB(kWhite);
    self.labelFemale.layer.masksToBounds = YES;
    self.labelFemale.layer.cornerRadius = self.maleBGView.frame.size.height/2.0;
    [self.femaleBGView addSubview:self.labelFemale];
    
    //    [self.maleSlider setThumbImage:[UIImage imageNamed:@"man"] forState:UIControlStateNormal];
    [self.femaleSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - <滑块滑动方法>
- (void)sliderValueChanged:(UISlider *)slider{
    if (slider == self.maleSlider) {
        [slider setValue:slider.value animated:NO];
        if (!slider.isTracking && slider.value > 0.2) {
            [slider setValue:1 animated:YES];
        }else if(!slider.isTracking && slider.value < 0.2){
            NSLog(@"完成滑动");
            if ([self.tfPhone.text isEqualToString:@""]) {
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入手机号码"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [slider setValue:1 animated:YES];
            }else if ([self.tfPassword.text isEqualToString:@""]){
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入密码"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [slider setValue:1 animated:YES];
            }else if ([self.tfBirthday.text isEqualToString:@""]){
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请选择生日"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [slider setValue:1 animated:YES];
            }else if ([self.tfVerificationCode.text isEqualToString:@""]){
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入验证码"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [slider setValue:1 animated:YES];
            }else{
                self.gender = @"1";
                [self getRegisterData];
            }
        }
    }else if (slider == self.femaleSlider){
        [slider setValue:slider.value animated:NO];
        if (!slider.isTracking && slider.value < 0.8) {
            [slider setValue:0 animated:YES];
        }else if(!slider.isTracking && slider.value > 0.8){
            NSLog(@"完成滑动");
            if ([self.tfPhone.text isEqualToString:@""]) {
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入手机号码"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [slider setValue:0 animated:YES];
            }else if ([self.tfPassword.text isEqualToString:@""]){
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入密码"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [slider setValue:0 animated:YES];
            }else if ([self.tfBirthday.text isEqualToString:@""]){
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请选择生日"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [slider setValue:0 animated:YES];
            }else if ([self.tfVerificationCode.text isEqualToString:@""]){
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入验证码"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [slider setValue:0 animated:YES];
            }else{
                self.gender = @"2";
                [self getRegisterData];
            }
        }
    }
    
}

#pragma mark - <返回按钮响应>
- (IBAction)btnBackAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <获取验证码响应>
- (IBAction)btnVerificationCodeAction:(UIButton *)sender
{
    if ([self.tfPhone.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入手机号码"];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else{
        [self getSendMsgData];
    }
}

#pragma mark - <选择出生年月按钮响应>
- (void)selectBorthDateAction
{
    self.datePicker = [[STPickerDate alloc]init];
    self.datePicker.yearLeast = 1970;
    self.datePicker.yearSum = 200;
    self.datePicker.delegate = self;
    [self.datePicker show];
}

#pragma mark - <调用相机／相册用于更换头像>
-(void)changeMyHeadPotrait
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"优雅自拍" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectCamara];
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:@"浏览相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectAlbum];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:actionCamera];
    [alertVC addAction:actionAlbum];
    [alertVC addAction:actionCancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - <选择“优雅自拍”>
-(void)selectCamara
{
    //定义图片选择器
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];
    //判断系统是否允许选择相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 设置图片来源是相机
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置代理
        pickerVC.delegate = self;
        //模态显示界面
        [self presentViewController:pickerVC animated:YES completion:nil];
    }else{
        NSLog(@"不支持相机");
    }
}

#pragma mark - <选择“浏览相册”>
-(void)selectAlbum
{
    //定义图片选择器
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];
    //判断系统是否允许选择相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 设置图片来源是相册
        pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置代理
        pickerVC.delegate = self;
        //模态显示界面
        [self presentViewController:pickerVC animated:YES completion:nil];
    }
}













#pragma mark - ***** UITextFiledDelegate ******
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.tfBirthday) {
        [self.view endEditing:YES];
        [self selectBorthDateAction];
        return NO;
    }
    return YES;
}

#pragma mark - *** STPickerDateDelegate ***
-(void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    self.tfBirthday.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:self.tfBirthday.text];
    //时间转时间戳的方法:
    NSTimeInterval timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] doubleValue];
    timeSp = timeSp+28800;
    self.birthdayStr = [NSString stringWithFormat:@"%.0f",timeSp];
    
//    //时间戳转时间
//    NSTimeInterval time = [self.birthdayStr doubleValue];
//    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time];
}


#pragma mark - *** UIImagePickerControllerDelegate ****
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //通过key值获取相片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //纠正由拍照引起的图片旋转问题
    UIImage *imgPortrait = [UIImage fixOrientation:image];
    //转换为nsdata，用于判断图片是否存在
    NSData *dataImgPortrait = UIImageJPEGRepresentation(imgPortrait, 0.3);
    self.imgData = dataImgPortrait;
    
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self.imgPotrait setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self.imgPotrait setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//#pragma mark - **** HBLockSliderDelegate ****
//-(void)sliderEndValueChanged:(HBLockSliderView *)slider
//{
//    
//}


@end
