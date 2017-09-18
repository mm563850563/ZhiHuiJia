//
//  PersonalFileViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/17.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "PersonalFileViewController.h"

//views
#import "STPickerArea.h"
#import "STPickerDate.h"

//models
#import "PersonalInfoResultModel.h"
#import "PersonalInfoDataModel.h"

//tools
#import "UIImage+Orientation.h"
#import <AFNetworking.h>

@interface PersonalFileViewController ()<STPickerDateDelegate,STPickerAreaDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//outlets
@property (weak, nonatomic) IBOutlet UIImageView *imgHeaderPortrat;
@property (weak, nonatomic) IBOutlet UITextField *tfNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelBorthDate;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;
@property (weak, nonatomic) IBOutlet UITextView *tvSignature;
//@property (weak, nonatomic) IBOutlet UIButton *btnSelectMale;
//@property (weak, nonatomic) IBOutlet UIButton *btnSelectFemale;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGender;
@property (weak, nonatomic) IBOutlet UILabel *labelGender;


@property (nonatomic, strong)STPickerArea *areaPicker;
@property (nonatomic, strong)STPickerDate *datePicker;

@property (nonatomic, strong)PersonalInfoResultModel *modelResult;

@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *district;
@property (nonatomic, strong)NSData *dataImg;
@property (nonatomic, strong)NSString *dateStamp;

@end

@implementation PersonalFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPersonalInfoData];
    [self settingNavigation];
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

#pragma mark - <获取个人资料>
-(void)getPersonalInfoData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetPersonalInfo];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                NSError *error = nil;
                PersonalInfoDataModel *modelData = [[PersonalInfoDataModel alloc]initWithDictionary:dataDict[@"data"] error:&error];
                self.modelResult = modelData.result;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self fillDataToOutletsWithModel:self.modelResult];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <修改个人资料>
-(void)updatePersonalInfoDataWithPara:(NSDictionary *)dictParameter dataImage:(NSData *)dataImg
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUpdatePersonalInfo];
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
       parameters:dictParameter
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    
    if (dataImg) {
        [formData appendPartWithFileData:dataImg name:@"headimg" fileName:@"user_img.jpg" mimeType:@"image/jpeg"];
    }
}
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (responseObject) {
                  NSDictionary *dataDict = (NSDictionary *)responseObject;
                  NSNumber *code = (NSNumber *)dataDict[@"code"];
                  if ([code isEqual:@200]) {
                      self.modelResult = dataDict[@"data"];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hideAnimated:YES afterDelay:1.0];
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:1.0];
                          hudWarning.completionBlock = ^{
//                              [NSNotificationCenter defaultCenter]postNotificationName:@"refreshPortraitOnHomePage" object:<#(nullable id)#>
                              [self.navigationController popViewControllerAnimated:YES];
                          };
                      });
                  }else{
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [hud hideAnimated:YES afterDelay:1.0];
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:1.0];
                      });
                  }
              }else{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [hud hideAnimated:YES afterDelay:1.0];
                      MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                      [hudWarning hideAnimated:YES afterDelay:1.0];
                  });
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [hud hideAnimated:YES afterDelay:1.0];
                  MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                  [hudWarning hideAnimated:YES afterDelay:1.0];
              });
          }];
//
//    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
//    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
//        if (response) {
//            NSDictionary *dataDict = (NSDictionary *)response;
//            NSNumber *code = (NSNumber *)dataDict[@"code"];
//            if ([code isEqual:@200]) {
//                NSError *error = nil;
//                PersonalInfoDataModel *modelData = [[PersonalInfoDataModel alloc]initWithDictionary:dataDict[@"data"] error:&error];
//                self.modelResult = modelData.result;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES afterDelay:1.0];
//                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
//                    [hudWarning hideAnimated:YES afterDelay:1.0];
//                });
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [hud hideAnimated:YES afterDelay:1.0];
//                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
//                    [hudWarning hideAnimated:YES afterDelay:1.0];
//                });
//            }
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [hud hideAnimated:YES afterDelay:1.0];
//                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
//                [hudWarning hideAnimated:YES afterDelay:1.0];
//            });
//        }
//    } failBlock:^(NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [hud hideAnimated:YES afterDelay:1.0];
//            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
//            [hudWarning hideAnimated:YES afterDelay:1.0];
//        });
//    }];
}

#pragma mark - <填充数据>
-(void)fillDataToOutletsWithModel:(PersonalInfoResultModel *)model
{
    self.tfNickName.text = model.nickname;
    
    self.tvSignature.text = model.signature;
    
    self.labelArea.text = model.address;
    self.province = model.province;
    self.city = model.city;
    self.district = model.district;
    
    double t = [model.birthday doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    self.labelBorthDate.text = dateStr;
    self.dateStamp = model.birthday;
    
    //保存本地头像链接，下次修改资料时用于判断是否修改头像，节省资源
    kUserDefaultSetObject(model.headimg, kUserHeadimg);
    kUserDefaultSynchronize;
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgHeaderPortrat sd_setImageWithURL:url placeholderImage:kPlaceholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //把按钮中的图片转化成NSData，用于判断改图片是否存在
        NSData *dataMainImg = UIImageJPEGRepresentation(image,1);
        self.dataImg = dataMainImg;
    }];
    
    if ([model.sex isEqualToString:@"1"]) {
        self.imgViewGender.image = [UIImage imageNamed:@"male"];
        self.labelGender.text = @"男神";
    }else{
        self.imgViewGender.image = [UIImage imageNamed:@"female"];
        self.labelGender.text = @"女神";
    }
}

-(void)settingNavigation
{
    self.navigationItem.title = @"个人资料";
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - <选择出生年月按钮响应>
- (IBAction)btnSelectBorthDateAction:(UIButton *)sender
{
    self.datePicker = [[STPickerDate alloc]init];
    self.datePicker.yearLeast = 1970;
    self.datePicker.yearSum = 200;
    self.datePicker.delegate = self;
    [self.datePicker show];
    
    [self.view endEditing:YES];
}

#pragma mark - <选择所在地区按钮响应>
- (IBAction)btnSelectAreaAction:(UIButton *)sender
{
    self.areaPicker = [[STPickerArea alloc]init];
    self.areaPicker.delegate = self;
    [self.areaPicker show];
    
    [self.view endEditing:YES];
}

#pragma mark - <更换头像按钮响应>
- (IBAction)btnSelectMyHeadPortrait:(id)sender
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


#pragma mark - <选择男神按钮响应>
- (IBAction)btnSelectMaleAction:(UIButton *)sender
{
//    [self.btnSelectMale setBackgroundColor:kColorFromRGB(kBlack)];
//    [self.btnSelectFemale setBackgroundColor:kColorFromRGB(kLightGray)];
}

#pragma mark - <选择女神按钮响应>
- (IBAction)btnSelectFemaleAction:(id)sender
{
//    [self.btnSelectMale setBackgroundColor:kColorFromRGB(kLightGray)];
//    [self.btnSelectFemale setBackgroundColor:kColorFromRGB(kBlack)];
}

#pragma mark - <保存个人资料>
- (IBAction)btnSaveAction:(UIButton *)sender
{
    NSMutableDictionary *dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:kUserDefaultObject(kUserInfo) forKey:@"user_id"];
    [dictParameter setObject:self.dateStamp forKey:@"birthday"];
    [dictParameter setObject:self.province forKey:@"province"];
    [dictParameter setObject:self.city forKey:@"city"];
    [dictParameter setObject:self.district forKey:@"district"];
    
    if (![self.tfNickName.text isEqualToString:@""]) {
        [dictParameter setObject:self.tfNickName.text forKey:@"username"];
    }
    if(![self.tvSignature.text isEqualToString:@""]){
        [dictParameter setObject:self.tvSignature.text forKey:@"signature"];
    }
    
    if (kUserDefaultObject(kUserHeadimg)) {
        [self updatePersonalInfoDataWithPara:dictParameter dataImage:nil];
    }else{
        [self updatePersonalInfoDataWithPara:dictParameter dataImage:self.dataImg];
    }
    
}









#pragma mark - *** STPickerDateDelegate ***
-(void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    self.labelBorthDate.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:self.labelBorthDate.text];
    double t = [date timeIntervalSince1970];
    self.dateStamp = [NSString stringWithFormat:@"%.0f",t+28800];
}

#pragma mark - **** STPickerAreaDelegate ****
-(void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area provinceID:(nonnull NSString *)provinceID cityID:(nonnull NSString *)cityID areaID:(nonnull NSString *)areaID
{
    NSMutableArray *array = [NSMutableArray array];
    if (![province isEqualToString:@""]) {
        [array addObject:province];
    }
    if (![city isEqualToString:@""]){
        [array addObject:city];
    }
    if (![area isEqualToString:@""]){
        [array addObject:area];
    }
    
    NSString *string = province;
    for (int i = 1; i < array.count; i++) {
        string = [string stringByAppendingFormat:@">%@",array[i]];
    }
    self.labelArea.text = string;
    
    self.province = provinceID;
    self.city = cityID;
    self.district = areaID;
}

#pragma mark - *** UIImagePickerControllerDelegate ****
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //通过key值获取相片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self.imgHeaderPortrat setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self.imgHeaderPortrat setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    //把按钮中的图片转化成NSData，用于判断改图片是否存在
    UIImage *imgMain = [UIImage fixOrientation:image];
    NSData *dataMainImg = UIImageJPEGRepresentation(imgMain,0.3);
    self.dataImg = dataMainImg;
    
    //用户选择了头像，移除原本的头像链接
    kUserDefaultRemoveObject(kUserHeadimg);
    kUserDefaultSynchronize;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
