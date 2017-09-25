//
//  ActivityReportViewcontroller.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityReportViewcontroller.h"

//tools
#import "UIImage+Orientation.h"

//controllers
//#import <TZImagePickerController.h>

@interface ActivityReportViewcontroller ()<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong)UIImagePickerController *pickerReportPhoto;
@property (nonatomic, strong)NSData *dataImg;

@property (weak, nonatomic) IBOutlet UITextView *feedbackView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewReport;

@end

@implementation ActivityReportViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - <配置outlets>
-(void)settingOutlets
{
    //给imagViewReport 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImgViewReportActionWithGestureRecohnize:)];
    self.imgViewReport.userInteractionEnabled = YES;
    [self.imgViewReport addGestureRecognizer:tap];
    
    //
    self.feedbackView.delegate = self;
    self.placeholder.userInteractionEnabled = NO;
}

#pragma mark - <点击“添加举报图片”响应>
-(void)clickImgViewReportActionWithGestureRecohnize:(UITapGestureRecognizer *)tap
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
    self.pickerReportPhoto = [[UIImagePickerController alloc]init];
    //判断系统是否允许选择相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 设置图片来源是相机
        self.pickerReportPhoto.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置代理
        self.pickerReportPhoto.delegate = self;
        //模态显示界面
        [self presentViewController:self.pickerReportPhoto animated:YES completion:nil];
    }else{
        NSLog(@"不支持相机");
    }
}

#pragma mark - <选择“浏览相册”>
-(void)selectAlbum
{
    //定义图片选择器
    self.pickerReportPhoto = [[UIImagePickerController alloc]init];
    //判断系统是否允许选择相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 设置图片来源是相册
        self.pickerReportPhoto.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置代理
        self.pickerReportPhoto.delegate = self;
        //模态显示界面
        [self presentViewController:self.pickerReportPhoto animated:YES completion:nil];
    }
}


#pragma mark - <提交举报>
- (IBAction)btnSubmitAction:(UIButton *)sender
{
    MBProgressHUD *hudWarnning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"提交"];
    [hudWarnning hideAnimated:YES afterDelay:1.0];
}












#pragma mark - ***** UITextViewDelegate ******
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    //允许提交按钮点击操作
    //    self.commitButton.backgroundColor = FDMainColor;
    //    self.commitButton.userInteractionEnabled = YES;
    //实时显示字数
    self.limitLabel.text = [NSString stringWithFormat:@"%lu/300", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 300) {
        
        textView.text = [textView.text substringToIndex:300];
        self.limitLabel.text = @"300/300";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeholder.hidden = NO;
        //        self.commitButton.userInteractionEnabled = NO;
        //        self.commitButton.backgroundColor = [UIColor lightGrayColor];
        
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
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self.imgViewReport setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [self.imgViewReport setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //把按钮中的图片转化成NSData，用于判断改图片是否存在
    UIImage *imgMain = [UIImage fixOrientation:image];
    NSData *dataMainImg = UIImageJPEGRepresentation(imgMain,0.3);
    self.dataImg = dataMainImg;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
