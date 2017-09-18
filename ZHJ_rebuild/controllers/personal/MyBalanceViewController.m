//
//  MyBalabceViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyBalanceViewController.h"




//controllers
#import "MyDiscountCouponViewController.h"

@interface MyBalanceViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelMyWallet;
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfCoupon;

@end

@implementation MyBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getMyWalletData];
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


#pragma mark - <我的钱包数据>
-(void)getMyWalletData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kMyWallet];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                NSDictionary *result = dataDict[@"data"][@"result"];
                [self fillDataWithResult:result];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager
                                             showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager
                                         showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <填充页面数据>
-(void)fillDataWithResult:(NSDictionary *)result
{
    self.labelMyWallet.text = [NSString stringWithFormat:@"¥%@",result[@"user_money"]];
    
    self.labelNumberOfCoupon.text = [NSString stringWithFormat:@"%@",result[@"coupon_count"]];
}

#pragma mark - <跳转我的优惠券页面>
-(void)jumpToMyCouponVCWithType:(NSString *)type
{
    MyDiscountCouponViewController *myCouponVC = [[MyDiscountCouponViewController alloc]initWithNibName:NSStringFromClass([MyDiscountCouponViewController class]) bundle:nil];
    myCouponVC.available = type;
    [self.navigationController pushViewController:myCouponVC animated:YES];
}

#pragma mark - <可用优惠券响应>
- (IBAction)btnMyAvailableCouponAction:(UIButton *)sender
{
    [self jumpToMyCouponVCWithType:@"available"];
}





@end
