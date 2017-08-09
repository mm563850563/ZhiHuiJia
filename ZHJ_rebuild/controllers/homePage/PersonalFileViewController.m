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

@interface PersonalFileViewController ()<STPickerDateDelegate,STPickerAreaDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//outlets
@property (weak, nonatomic) IBOutlet UIImageView *imgHeaderPortrat;
@property (weak, nonatomic) IBOutlet UITextField *tfNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelBorthDate;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;
@property (weak, nonatomic) IBOutlet UITextView *tvSignature;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectMale;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectFemale;


@property (nonatomic, strong)STPickerArea *areaPicker;
@property (nonatomic, strong)STPickerDate *datePicker;



@end

@implementation PersonalFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

-(void)settingNavigation
{
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
}

#pragma mark - <选择所在地区按钮响应>
- (IBAction)btnSelectAreaAction:(UIButton *)sender
{
    self.areaPicker = [[STPickerArea alloc]init];
    self.areaPicker.delegate = self;
    [self.areaPicker show];
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
    [self.btnSelectMale setBackgroundColor:kColorFromRGB(kBlack)];
    [self.btnSelectFemale setBackgroundColor:kColorFromRGB(kLightGray)];
}

#pragma mark - <选择女神按钮响应>
- (IBAction)btnSelectFemaleAction:(id)sender
{
    [self.btnSelectMale setBackgroundColor:kColorFromRGB(kLightGray)];
    [self.btnSelectFemale setBackgroundColor:kColorFromRGB(kBlack)];
}










#pragma mark - *** STPickerDateDelegate ***
-(void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    self.labelBorthDate.text = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
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
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
