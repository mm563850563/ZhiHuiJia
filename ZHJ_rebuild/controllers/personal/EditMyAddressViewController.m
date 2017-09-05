//
//  EditMyAddressViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/9.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "EditMyAddressViewController.h"
#import "UserAddressListResultModel.h"

//views
#import "STPickerArea.h"

@interface EditMyAddressViewController ()<STPickerAreaDelegate>

@property (nonatomic, strong)STPickerArea *areaPicker;
@property (nonatomic, strong)NSString *provinceID;
@property (nonatomic, strong)NSString *cityID;
@property (nonatomic, strong)NSString *areaID;
@property (nonatomic, strong)NSString *isDefault;

@property (weak, nonatomic) IBOutlet UITextField *tfContactName;
@property (weak, nonatomic) IBOutlet UITextField *tfContactPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfContactAddress;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UILabel *labelArea;

@end

@implementation EditMyAddressViewController

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

-(void)settingOutlets
{
    self.tfContactName.text = self.model.consignee;
    self.tfContactPhone.text = self.model.mobile;
    self.tfContactAddress.text = self.model.address;
    self.labelArea.text = self.model.area;
    self.provinceID = self.model.province;
    self.cityID = self.model.city;
    self.areaID = self.model.district;
    
    if ([self.model.is_default isEqualToString:@"1"]) {
        self.switcher.on = YES;
        self.isDefault = @"1";
    }else{
        self.switcher.on = NO;
        self.isDefault = @"0";
    }
}

#pragma mark - <点击“所在地区”响应>
- (IBAction)btnSelectAreaAction:(UIButton *)sender
{
    //收回键盘
    [self.view endEditing:YES];
    //弹起pickerView
    self.areaPicker = [[STPickerArea alloc]init];
    self.areaPicker.delegate = self;
    [self.areaPicker show];
}

#pragma mark - <设置为默认>
- (IBAction)switcherDefaultAction:(UISwitch *)sender
{
    if (sender.on) {
        self.isDefault = @"1";
    }else{
        self.isDefault = @"0";
    }
}


#pragma  mark - <提交修改地址响应>
- (IBAction)btnSubmitAction:(UIButton *)sender
{
    if ([self.tfContactName.text isEqualToString:@""] || [self.tfContactPhone.text isEqualToString:@""] || [self.tfContactAddress.text isEqualToString:@""] || !self.provinceID || !self.cityID || !self.areaID) {
        NSString *warningStr = @"";
        if ([self.tfContactName.text isEqualToString:@""]) {
            warningStr = @"请填写收货人";
        }else if ([self.tfContactPhone.text isEqualToString:@""]){
            warningStr = @"请填写手机号码";
        }else if ([self.tfContactAddress.text isEqualToString:@""]){
            warningStr = @"请填写详细地址";
        }else if (!self.provinceID || !self.cityID || !self.areaID){
            warningStr = @"请选择所在地区";
        }
        MBProgressHUD *hud = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:warningStr];
        [hud hideAnimated:YES afterDelay:2.0];
    }else{
        [self getUpdateAddressData];
    }
    
}

#pragma mark - <提交修改收货地址>
-(void)getUpdateAddressData
{
    if (![self.tfContactName.text isEqualToString:@""] || ![self.tfContactPhone.text isEqualToString:@""] || ![self.tfContactAddress.text isEqualToString:@""] || self.provinceID || self.cityID || self.areaID || kUserDefaultObject(kUserInfo)) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUpdateAddres];
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                        @"address_id":self.model.address_id,
                                        @"consignee":self.tfContactName.text,
                                        @"mobile":self.tfContactPhone.text,
                                        @"address":self.tfContactAddress.text,
                                        @"is_default":self.isDefault,
                                        @"province":self.provinceID,
                                        @"city":self.cityID,
                                        @"district":self.areaID};
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                NSNumber *code = (NSNumber *)response[@"code"];
                if ([code isEqual:@200]) {
                    //通知地址列表刷新页面
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"submitAfterModifyAddress" object:nil];
                    
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    hudWarning.completionBlock = ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                }else{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}










#pragma mark - **** STPickerAreaDelegate ****
-(void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area provinceID:(nonnull NSString *)provinceID cityID:(nonnull NSString *)cityID areaID:(nonnull NSString *)areaID
{
    self.provinceID = provinceID;
    self.cityID = cityID;
    self.areaID = areaID;
    NSLog(@"%@-%@-%@",provinceID,cityID,areaID);
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


@end
