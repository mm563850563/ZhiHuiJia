//
//  ReleaseActivityViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ReleaseActivityViewController.h"

//cells
#import "ReleaseActivityUploadImageCell.h"
#import "ReleaseActivityContentCell.h"
#import "ReleaseActivitySubmitToReviewCell.h"

//tools
#import "UIImage+Orientation.h"
#import <AFNetworking.h>

//controllers

//views
#import "STPickerArea.h"
#import "STPickerDate.h"

@interface ReleaseActivityViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,STPickerAreaDelegate,STPickerDateDelegate>

@property (nonatomic, strong)UIImagePickerController *pickerPhoto;

@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfStartTime;
@property (weak, nonatomic) IBOutlet UITextField *tfEndTime;
@property (weak, nonatomic) IBOutlet UITextField *tfRegion;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfInitiator;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfFee;
@property (weak, nonatomic) IBOutlet UITextField *tfDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imgUpload;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;

@property (nonatomic, strong)STPickerArea *pickerArea;
@property (nonatomic, strong)STPickerDate *pickerDateStart;
@property (nonatomic, strong)STPickerDate *pickerDateEnd;

@property (nonatomic, strong)NSData *selectedImgData;//被选中的图片转换成的data
@property (nonatomic, strong)NSString *timeStart;//活动开始时间
@property (nonatomic, strong)NSString *timeEnd;//活动结束时间
@property (nonatomic, strong)NSString *provinceID;//省ID
@property (nonatomic, strong)NSString *cityID;//市ID
@property (nonatomic, strong)NSString *districtID;//区ID


@end

@implementation ReleaseActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingOutlets];
    [self settingHeightForScrollView];
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(UIImagePickerController *)pickerPhoto
{
    if (!_pickerPhoto) {
        _pickerPhoto = [[UIImagePickerController alloc]init];
    }
    return _pickerPhoto;
}

-(STPickerArea *)pickerArea
{
    if (!_pickerArea) {
        _pickerArea = [[STPickerArea alloc]init];
        _pickerArea.delegate = self;
    }
    return _pickerArea;
}

-(STPickerDate *)pickerDateStart
{
    if (!_pickerDateStart) {
        _pickerDateStart = [[STPickerDate alloc]init];
        _pickerDateStart.delegate = self;
        _pickerDateStart.yearLeast = 1970;
        _pickerDateStart.yearSum = 200;
    }
    return _pickerDateStart;
}

-(STPickerDate *)pickerDateEnd
{
    if (!_pickerDateEnd) {
        _pickerDateEnd = [[STPickerDate alloc]init];
        _pickerDateEnd.delegate = self;
        _pickerDateEnd.yearLeast = 1970;
        _pickerDateEnd.yearSum = 200;
    }
    return _pickerDateEnd;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取“发布活动”数据>
-(void)getApplyActivityDataWithPara:(NSDictionary *)para file:(NSData *)file
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kApplyForActivity];
    
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
    [manager POST:urlStr parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:file name:@"image" fileName:@"temp.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    hudWarning.completionBlock = ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <初始化各个参数>
-(void)settingOutlets
{
    self.tfEndTime.delegate = self;
    self.tfStartTime.delegate = self;
    self.tfRegion.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callCameraOrAblum)];
    self.imgUpload.userInteractionEnabled = YES;
    [self.imgUpload addGestureRecognizer:tap];
}

-(void)showWarningHudWithText:(NSString *)text
{
    MBProgressHUD *hud = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:text];
    [hud hideAnimated:YES afterDelay:2.0];
}

#pragma mark - <提交审核按钮响应>
- (IBAction)btnSubmitToReviewAction:(UIButton *)sender
{
    if (!self.selectedImgData) {
        [self showWarningHudWithText:@"请选择活动封面图"];
    }else if ([self.tfTitle.text isEqualToString:@""]){
        [self showWarningHudWithText:@"请填写活动标题"];
    }else if (!self.timeStart){
        [self showWarningHudWithText:@"请选择活动开始时间"];
    }else if (!self.timeEnd){
        [self showWarningHudWithText:@"请选择活动结束时间"];
    }else if (!self.provinceID || !self.cityID || !self.districtID){
        [self showWarningHudWithText:@"请选择活动地点"];
    }else if ([self.tfAddress.text isEqualToString:@""]){
        [self showWarningHudWithText:@"请填写活动详细地址"];
    }else if ([self.tfInitiator.text isEqualToString:@""]){
        [self showWarningHudWithText:@"请填写真实姓名"];
    }else if ([self.tfPhone.text isEqualToString:@""]){
        [self showWarningHudWithText:@"请填写联系电话"];
    }else if ([self.tfFee.text isEqualToString:@""]){
        [self showWarningHudWithText:@"请填写活动费用"];
    }else if ([self.tfDetail.text isEqualToString:@""]){
        [self showWarningHudWithText:@"请填写活动详情"];
    }else{
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                        @"title":self.tfTitle.text,
                                        @"start_time":self.timeStart,
                                        @"end_time":self.timeEnd,
                                        @"province":self.provinceID,
                                        @"city":self.cityID,
                                        @"district":self.districtID,
                                        @"location":self.tfAddress.text,
                                        @"initiator":self.tfInitiator.text,
                                        @"mobile":self.tfPhone.text,
                                        @"entry_fee":self.tfFee.text,
                                        @"content":self.tfDetail.text};
        [self getApplyActivityDataWithPara:dictParameter file:self.selectedImgData];
    }
}

#pragma mark - <调起相机／相册>
-(void)callCameraOrAblum
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
    //判断系统是否允许选择相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 设置图片来源是相机
        self.pickerPhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置代理
        self.pickerPhoto.delegate = self;
        //模态显示界面
        [self presentViewController:self.pickerPhoto animated:YES completion:nil];
    }else{
        NSLog(@"不支持相机");
    }
}

#pragma mark - <选择“浏览相册”>
-(void)selectAlbum
{
    //判断系统是否允许选择相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 设置图片来源是相册
        self.pickerPhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置代理
        self.pickerPhoto.delegate = self;
        //模态显示界面
        [self presentViewController:self.pickerPhoto animated:YES completion:nil];
    }
}

#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    self.heightForScrollView.constant = kSCREEN_WIDTH+413+100;
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    
}




















#pragma mark - *** UIImagePickerControllerDelegate ****
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //通过key值获取相片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (picker == self.pickerPhoto) {
        //判断数据源类型
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            self.imgUpload.image = image;
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            self.imgUpload.image = image;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        //把按钮中的图片转化成NSData，用于判断改图片是否存在
        UIImage *imgMain = [UIImage fixOrientation:image];
        NSData *dataMainImg = UIImageJPEGRepresentation(imgMain,0.3);
        self.selectedImgData = dataMainImg;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - *** UITextFieldDelegate ****
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.tfRegion) {
        [self.view endEditing:YES];
        [self.pickerArea show];
        return NO;
    }else if (textField == self.tfStartTime){
        [self.view endEditing:YES];
        [self.pickerDateStart show];
        return NO;
    }else if (textField == self.tfEndTime){
        [self.view endEditing:YES];
        [self.pickerDateEnd show];
        return NO;
    }
    return YES;
}

#pragma mark - *** STPickerDateDelegate ***
-(void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSTimeInterval timeInterval = [date timeIntervalSince1970]+28800;
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f",timeInterval];
    
    //    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    
    if (pickerDate == self.pickerDateStart) {
        self.tfStartTime.text = dateStr;
        self.timeStart = timeStamp;
    }else if (pickerDate == self.pickerDateEnd){
        self.tfEndTime.text = dateStr;
        self.timeEnd = timeStamp;
    }
}

#pragma mark - **** STPickerAreaDelegate ***
-(void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area provinceID:(NSString *)provinceID cityID:(NSString *)cityID areaID:(NSString *)areaID
{
    self.provinceID = provinceID;
    self.cityID = cityID;
    self.districtID = areaID;
    
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
    self.tfRegion.text = string;
}


@end
