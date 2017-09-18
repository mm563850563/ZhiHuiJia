//
//  ApplyCircleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ApplyCircleViewController.h"

//tools
#import <AFNetworking.h>
#import "UIImage+Orientation.h"

//views
#import "STPickerSingle.h"

//controllers
#import <TZImagePickerController.h>


#define kCircleCategory @"CircleCategory"

@interface ApplyCircleViewController ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;

@property (weak, nonatomic) IBOutlet UITextField *tfCircleName;
@property (weak, nonatomic) IBOutlet UITextField *tfCircleCategory;
@property (weak, nonatomic) IBOutlet UITextView *tvCircleDescription;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIButton *btnCircleMainPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnCircleDetailPhoto;

@property (nonatomic, strong)UIView *cloudGlassBGView;
@property (nonatomic, strong)UITableView *tableViewCircleCategory;
@property (nonatomic, strong)NSMutableArray *circleCategoryArray;
@property (nonatomic, strong)NSString *circleCategoryID;

@property (nonatomic, strong)UIImagePickerController *pickerMainPhoto;
@property (nonatomic, strong)UIImagePickerController *pickerDetailPhoto;
@property (nonatomic, strong)NSData *dataMainImg;
@property (nonatomic, strong)NSData *dataDetailImg;

@end

@implementation ApplyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getCircleCategoryData];
    [self settingOutlets];
    [self settingHeightForScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)circleCategoryArray
{
    if (!_circleCategoryArray) {
        _circleCategoryArray = [NSMutableArray array];
    }
    return _circleCategoryArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取圈子分类数据>
-(void)getCircleCategoryData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kAllCircleClassify];
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:nil progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                self.circleCategoryArray = [NSMutableArray arrayWithArray:dataDict[@"data"][@"result"]];
                [self.circleCategoryArray addObject:@"取消"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableViewCircleCategory reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
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

#pragma mark - <设置outlets>
-(void)settingOutlets
{
    self.tvCircleDescription.delegate = self;
    self.tfCircleCategory.delegate = self;
}

#pragma mark - <初始化“选择分类”列表>
-(UITableView *)tableViewCircleCategory
{
    if (!_tableViewCircleCategory) {
        self.cloudGlassBGView = [[UIView alloc]initWithFrame:kScreeFrame];
        self.cloudGlassBGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTheCloudGlassBGView)];
        [self.cloudGlassBGView addGestureRecognizer:tap];
        
        _tableViewCircleCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, kSCREEN_WIDTH, 250) style:UITableViewStylePlain];
        _tableViewCircleCategory.delegate = self;
        _tableViewCircleCategory.dataSource = self;
        _tableViewCircleCategory.rowHeight = 40;
        [_tableViewCircleCategory registerClass:[UITableViewCell class] forCellReuseIdentifier:kCircleCategory];
        [self.view addSubview:_tableViewCircleCategory];
    }
    return _tableViewCircleCategory;
}

#pragma mark - <给蒙板添加de点击事件>
-(void)removeTheCloudGlassBGView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.tableViewCircleCategory.frame = CGRectMake(0, self.view.frame.size.height, kSCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        [self.cloudGlassBGView removeFromSuperview];
    }];
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

#pragma mark - <圈子主图按钮>
- (IBAction)btnCircleMainPhotoAction:(UIButton *)sender
{
    [self callCameraOrAblumWithCallType:@"mainPhoto"];
}

#pragma mark - <圈子详情图片按钮>
- (IBAction)btnCircleDetailPhotoAction:(UIButton *)sender
{
    [self callCameraOrAblumWithCallType:@"detailPhoto"];
}

#pragma mark - <提交按钮响应>
- (IBAction)btnSubmitAction:(UIButton *)sender
{
    if ([self.tfCircleName.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请填写圈子名称"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if ([self.circleCategoryID isEqualToString:@""] || [self.tfCircleCategory.text isEqualToString:@""]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请选择圈子分类"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if ([self.tvCircleDescription.text isEqualToString:@""]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请填写圈子简介"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if (!self.dataMainImg){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请选择圈子主图"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if (!self.dataDetailImg){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请选择圈子详情图"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        [self getApplyForCircleData];
    }
}

#pragma mark - <获取申请圈子数据>
-(void)getApplyForCircleData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kApplyForCircle];
    
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
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[kUserDefaultObject(kUserInfo) dataUsingEncoding:NSUTF8StringEncoding] name:@"user_id"];
        [formData appendPartWithFormData:[self.tfCircleName.text dataUsingEncoding:NSUTF8StringEncoding] name:@"circle_name"];
        [formData appendPartWithFormData:[self.circleCategoryID dataUsingEncoding:NSUTF8StringEncoding] name:@"classify_id"];
        [formData appendPartWithFormData:[self.tvCircleDescription.text dataUsingEncoding:NSUTF8StringEncoding] name:@"description"];
        
        [formData appendPartWithFileData:self.dataMainImg name:@"logo" fileName:@"erkan.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:self.dataDetailImg name:@"img" fileName:@"erkan2.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%lld",uploadProgress.completedUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *dataDict = (NSDictionary *)responseObject;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
    
}

#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    if (self.view.frame.size.height > self.heightForScrollView.constant) {
        self.heightForScrollView. constant = self.view.frame.size.height;
    }else{
        self.heightForScrollView.constant = 600;
    }
}








#pragma mark - ***** UITextFiledDelegate *****
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.tfCircleCategory) {
        [self.view endEditing:YES];
        [self.view insertSubview:self.cloudGlassBGView belowSubview:self.tableViewCircleCategory];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableViewCircleCategory.frame = CGRectMake(0, self.view.frame.size.height-250, kSCREEN_WIDTH, 250);
        }];
        return NO;
    }
    return YES;
}

#pragma mark - **** UITextViewDelegate *****
-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    if (textView.text.length == 0) {
        self.placeholder.hidden = NO;
    }
}

#pragma mark - **** UITableViewDelegate,UITableViewDataSource *****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.circleCategoryArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCircleCategory];
    if (self.circleCategoryArray.count-1 != indexPath.row) {
        NSDictionary *dict = self.circleCategoryArray[indexPath.row];
        cell.textLabel.text = dict[@"classify_name"];
    }else{
        cell.textLabel.text = self.circleCategoryArray[indexPath.row];
    }
    cell.textLabel.textAlignment = 1;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.circleCategoryArray.count-1 != indexPath.row) {
        NSDictionary *dict = self.circleCategoryArray[indexPath.row];
        [UIView animateWithDuration:0.3 animations:^{
            self.tableViewCircleCategory.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 250);
        } completion:^(BOOL finished) {
            [self.cloudGlassBGView removeFromSuperview];
            self.tfCircleCategory.text = dict[@"classify_name"];
            self.circleCategoryID = dict[@"classify_id"];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.tableViewCircleCategory.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 250);
        } completion:^(BOOL finished) {
            [self.cloudGlassBGView removeFromSuperview];
        }];
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
            [self.btnCircleMainPhoto setImage:image forState:UIControlStateNormal];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [self.btnCircleMainPhoto setImage:image forState:UIControlStateNormal];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        //把按钮中的图片转化成NSData，用于判断改图片是否存在
        UIImage *imgMain = [UIImage fixOrientation:image];
        NSData *dataMainImg = UIImageJPEGRepresentation(imgMain,0.3);
        self.dataMainImg = dataMainImg;
    }else if (picker == self.pickerDetailPhoto){
        if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [self.btnCircleDetailPhoto setImage:image forState:UIControlStateNormal];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [self.btnCircleDetailPhoto setImage:image forState:UIControlStateNormal];
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
