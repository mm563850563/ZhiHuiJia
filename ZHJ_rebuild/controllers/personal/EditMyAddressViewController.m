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
@property (nonatomic, strong)NSString *proviceID;
@property (nonatomic, strong)NSString *cityID;
@property (nonatomic, strong)NSString *areaID;

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
}

#pragma mark - <点击“所在地区”响应>
- (IBAction)btnSelectAreaAction:(UIButton *)sender
{
    self.areaPicker = [[STPickerArea alloc]init];
    self.areaPicker.delegate = self;
    [self.areaPicker show];
}

#pragma  mark - <提交修改地址响应>
- (IBAction)btnSubmitAction:(UIButton *)sender
{
    [NSNotificationCenter defaultCenter]postNotificationName:@"submitAfterModifyAddress" object:<#(nullable id)#>
}







#pragma mark - **** STPickerAreaDelegate ****
-(void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area provinceID:(nonnull NSString *)provinceID cityID:(nonnull NSString *)cityID areaID:(nonnull NSString *)areaID
{
    self.proviceID = provinceID;
    self.cityID = cityID;
    self.areaID = areaID;
    
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
