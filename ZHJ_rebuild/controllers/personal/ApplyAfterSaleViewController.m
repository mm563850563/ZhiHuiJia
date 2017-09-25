//
//  ApplyAfterSaleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ApplyAfterSaleViewController.h"

//models
#import "OrderListGoodsModel.h"

//tools
#import "UIImage+Color.h"

@interface ApplyAfterSaleViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewGoods;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *labelSpecName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelGoodsCount;
@property (weak, nonatomic) IBOutlet UIButton *btnRepair;
@property (weak, nonatomic) IBOutlet UIButton *btnRefund;
@property (weak, nonatomic) IBOutlet UITextView *feedbackView;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@property (nonatomic, strong)NSString *service_type;

@end

@implementation ApplyAfterSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"申请维修/退款";
    // Do any additional setup after loading the view from its nib.
    
    [self settingOutlets];
    [self settingHeightForScrollView];
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

#pragma mark - <提交申请售后服务>
-(void)requestApplyAfterSale
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kReturnGoods];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"goods_id":self.modelGoods.goods_id,
                                    @"spec_key":self.modelGoods.spec_key,
                                    @"reason":self.feedbackView.text,
                                    @"order_sn":self.order_sn,
                                    @"type":self.service_type,
                                    @"order_id":self.order_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = dataDict[@"code"];
            if ([code isEqual:@200]) {
                //回到主线程刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hudWarning.completionBlock = ^{
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
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <配置Outlets>
-(void)settingOutlets
{
    //问题描述
    self.feedbackView.delegate = self;
    self.placeholder.userInteractionEnabled = NO;
    
    //”维修“按钮正常状态
    UIImage *themeColorImg = [UIImage imageWithColor:kColorFromRGB(kThemeYellow) height:1];
    UIImage *whiteColorImg = [UIImage imageWithColor:kColorFromRGB(kWhite) height:1];
    
    [self.btnRepair setTitle:@"维修" forState:UIControlStateNormal];
    [self.btnRepair setTitleColor:kColorFromRGB(kThemeYellow) forState:UIControlStateNormal];
    [self.btnRepair setBackgroundImage:whiteColorImg forState:UIControlStateNormal];
    self.btnRepair.layer.borderWidth = 1;
    self.btnRepair.layer.borderColor = kColorFromRGB(kThemeYellow).CGColor;
    self.btnRepair.layer.cornerRadius = 3;
    self.btnRepair.layer.masksToBounds = YES;
    //”维修“按钮选中状态
    [self.btnRepair setTitle:@"维修" forState:UIControlStateSelected];
    [self.btnRepair setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateSelected];
    [self.btnRepair setBackgroundImage:themeColorImg forState:UIControlStateSelected];
    self.btnRepair.layer.borderWidth = 1;
    self.btnRepair.layer.borderColor = kColorFromRGB(kThemeYellow).CGColor;
    self.btnRepair.layer.cornerRadius = 3;
    self.btnRepair.layer.masksToBounds = YES;
    //”维修“按钮正常状态
    [self.btnRefund setTitle:@"退款" forState:UIControlStateNormal];
    [self.btnRefund setTitleColor:kColorFromRGB(kThemeYellow) forState:UIControlStateNormal];
    [self.btnRefund setBackgroundImage:whiteColorImg forState:UIControlStateNormal];
    self.btnRefund.layer.borderWidth = 1;
    self.btnRefund.layer.borderColor = kColorFromRGB(kThemeYellow).CGColor;
    self.btnRefund.layer.cornerRadius = 3;
    self.btnRefund.layer.masksToBounds = YES;
    //”维修“按钮选中状态
    [self.btnRefund setTitle:@"退款" forState:UIControlStateSelected];
    [self.btnRefund setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateSelected];
    [self.btnRefund setBackgroundImage:themeColorImg forState:UIControlStateSelected];
    self.btnRefund.layer.borderWidth = 1;
    self.btnRefund.layer.borderColor = kColorFromRGB(kThemeYellow).CGColor;
    self.btnRefund.layer.cornerRadius = 3;
    self.btnRefund.layer.masksToBounds = YES;
    
    //服务类型
    self.service_type = @"2";
    self.btnRepair.selected = YES;
    self.btnRefund.selected = NO;
    
    //商品基本信息
    NSString *imgStr = self.modelGoods.image;
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewGoods sd_setImageWithURL:url placeholderImage:kPlaceholder];
    self.labelGoodsName.text = [NSString stringWithFormat:@"%@",self.modelGoods.goods_name];
    self.labelSpecName.text = [NSString stringWithFormat:@"%@",self.modelGoods.spec_key_name];
    self.labelPrice.text = [NSString stringWithFormat:@"价格:%@",self.modelGoods.goods_price];
    self.labelGoodsCount.text = [NSString stringWithFormat:@"数量:x%@",self.modelGoods.goods_num];
}

#pragma mark - <提交申请售后>
- (IBAction)btnSubmitAction:(UIButton *)sender
{
    if ([self.feedbackView.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请填写问题描述"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"提交申请售后服务?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestApplyAfterSale];
        }];
        [alertVC addAction:actionCancel];
        [alertVC addAction:actionConfirm];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}
#pragma mark - <选择维修>
- (IBAction)selectBtnRepairAction:(UIButton *)sender
{
    self.service_type = @"2";
    self.btnRepair.selected = YES;
    self.btnRefund.selected = NO;
}
#pragma mark - <选择退款>
- (IBAction)selectBtnRefundAction:(UIButton *)sender
{
    self.service_type = @"1";
    self.btnRepair.selected = NO;
    self.btnRefund.selected = YES;
}

#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    if (self.view.frame.size.height > 360) {
        self.heightForScrollView.constant = self.view.frame.size.height;
    }else{
        self.heightForScrollView.constant = 360;
    }
}









#pragma mark - ***** UITextViewDelegate ******
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        self.placeholder.hidden = NO;
    }
}



@end
