//
//  CreateTopicViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CreateTopicViewController.h"

//tools
#import "UIImage+Orientation.h"
#import <AFNetworking.h>

@interface CreateTopicViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewMainPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDetailPhoto;

@property (nonatomic, strong)UIImagePickerController *pickerMainPhoto;
@property (nonatomic, strong)UIImagePickerController *pickerDetailPhoto;
@property (nonatomic, strong)NSData *dataMainImg;
@property (nonatomic, strong)NSData *dataDetailImg;

@end

@implementation CreateTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self settingOutlets];
    [self settingHeightForScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <创建话题>
-(void)requestCreateTopicWithDictParameter:(NSDictionary *)dictParameter imgDataArray:(NSArray *)imgDataArray
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kCreateTopic];
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
    
    for (int i=0; i<imgDataArray.count; i++) {
        NSData *dataImg = imgDataArray[i];
        if (i == 0) {
            [formData appendPartWithFileData:dataImg name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }
        if (i == 1) {
            [formData appendPartWithFileData:dataImg name:@"banner" fileName:@"banner.jpg" mimeType:@"image/jpeg"];
        }
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
                          MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                          [hudWarning hideAnimated:YES afterDelay:2.0];
                          hudWarning.completionBlock = ^{
                              [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTopicLitOnSelectTopicVC" object:nil];
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
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [hud hideAnimated:YES afterDelay:1.0];
                  MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                  [hudWarning hideAnimated:YES afterDelay:2.0];
              });
          }];
}

#pragma mark - <配置outlets>
-(void)settingOutlets
{
    UITapGestureRecognizer *tapMainPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMainPhotoActionWithTap:)];
    self.imgViewMainPhoto.userInteractionEnabled = YES;
    [self.imgViewMainPhoto addGestureRecognizer:tapMainPhoto];
    
    UITapGestureRecognizer *tapDetailPhoto = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetailPhotoActionWithTap:)];
    self.imgViewDetailPhoto.userInteractionEnabled = YES;
    [self.imgViewDetailPhoto addGestureRecognizer:tapDetailPhoto];
}

#pragma mark - <点击主图手势响应>
-(void)tapMainPhotoActionWithTap:(UITapGestureRecognizer *)tap
{
    [self callCameraOrAblumWithCallType:@"mainPhoto"];
}

#pragma mark - <点击详情图手势响应>
-(void)tapDetailPhotoActionWithTap:(UITapGestureRecognizer *)tap
{
    [self callCameraOrAblumWithCallType:@"detailPhoto"];
}

#pragma mark - <保存按钮响应>
- (IBAction)btnSaveAction:(UIButton *)sender
{
    if ([self.tfTitle.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请填写活动标题"];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else if (!self.dataMainImg){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请上传主图"];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else if (!self.dataDetailImg){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请上传详情图"];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else{
        NSDictionary *dictParameter = @{@"title":self.tfTitle.text,
                                        @"user_id":kUserDefaultObject(kUserInfo),
                                        @"circle_id":self.circle_id};
        NSArray *tempArray = @[self.dataMainImg,self.dataDetailImg];
        [self requestCreateTopicWithDictParameter:dictParameter imgDataArray:tempArray];
    }
}

#pragma mark - <调起相机／相册>
-(void)callCameraOrAblumWithCallType:(NSString *)callType
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"优雅自拍" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectCamaraWithCallType:callType];
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:@"浏览相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectAlbumWithCallType:callType];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:actionCamera];
    [alertVC addAction:actionAlbum];
    [alertVC addAction:actionCancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - <选择“优雅自拍”>
-(void)selectCamaraWithCallType:(NSString *)callType
{
    //定义图片选择器
    if ([callType isEqualToString:@"mainPhoto"]) {
        self.pickerMainPhoto = [[UIImagePickerController alloc]init];
        //判断系统是否允许选择相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 设置图片来源是相机
            self.pickerMainPhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
            //设置代理
            self.pickerMainPhoto.delegate = self;
            //模态显示界面
            [self presentViewController:self.pickerMainPhoto animated:YES completion:nil];
        }else{
            NSLog(@"不支持相机");
        }
    }else if ([callType isEqualToString:@"detailPhoto"]){
        self.pickerDetailPhoto = [[UIImagePickerController alloc]init];
        //判断系统是否允许选择相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 设置图片来源是相机
            self.pickerDetailPhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
            //设置代理
            self.pickerDetailPhoto.delegate = self;
            //模态显示界面
            [self presentViewController:self.pickerDetailPhoto animated:YES completion:nil];
        }else{
            NSLog(@"不支持相机");
        }
    }
    
}

#pragma mark - <选择“浏览相册”>
-(void)selectAlbumWithCallType:(NSString *)callType
{
    //定义图片选择器
    if ([callType isEqualToString:@"mainPhoto"]) {
        self.pickerMainPhoto = [[UIImagePickerController alloc]init];
        //判断系统是否允许选择相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            // 设置图片来源是相册
            self.pickerMainPhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //设置代理
            self.pickerMainPhoto.delegate = self;
            //模态显示界面
            [self presentViewController:self.pickerMainPhoto animated:YES completion:nil];
        }
    }else if ([callType isEqualToString:@"detailPhoto"]){
        self.pickerDetailPhoto = [[UIImagePickerController alloc]init];
        //判断系统是否允许选择相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            // 设置图片来源是相册
            self.pickerDetailPhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //设置代理
            self.pickerDetailPhoto.delegate = self;
            //模态显示界面
            [self presentViewController:self.pickerDetailPhoto animated:YES completion:nil];
        }
    }
}

#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    if (self.view.frame.size.height > self.heightForScrollView.constant) {
        self.heightForScrollView. constant = self.view.frame.size.height;
    }else{
        self.heightForScrollView.constant = 400;
    }
}









#pragma mark - *** UIImagePickerControllerDelegate ****
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //通过key值获取相片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (picker == self.pickerMainPhoto) {
        //判断数据源类型
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [self.imgViewMainPhoto setImage:image];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [self.imgViewMainPhoto setImage:image];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        //把按钮中的图片转化成NSData，用于判断改图片是否存在
        UIImage *imgMain = [UIImage fixOrientation:image];
        NSData *dataMainImg = UIImageJPEGRepresentation(imgMain,0.3);
        self.dataMainImg = dataMainImg;
    }else if (picker == self.pickerDetailPhoto){
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [self.imgViewDetailPhoto setImage:image];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [self.imgViewDetailPhoto setImage:image];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        UIImage *imgDetail = [UIImage fixOrientation:image];
        NSData *dataDetailImg = UIImageJPEGRepresentation(imgDetail,0.3);
        self.dataDetailImg = dataDetailImg;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
