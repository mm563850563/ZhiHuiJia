//
//  MyDiscountCouponViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyDiscountCouponViewController.h"

//cells
#import "MyDiscountCouponCell.h"
#import "NULLTableViewCell.h"

//models
#import "MyDiscountCouponModel.h"
#import "MyDiscountCouponAvailableModel.h"
#import "MyDiscountCouponNormalModel.h"
#import "MyDiscountCouponExpiredModel.h"
#import "MyDiscountCouponUsedModel.h"

@interface MyDiscountCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *couponAvailableArray;
@property (nonatomic, strong)NSArray *couponUsedArray;
@property (nonatomic, strong)NSArray *couponNormalArray;
@property (nonatomic, strong)NSArray *couponExpiredArray;

@end

@implementation MyDiscountCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.available) {
        [self getAvailableCouponFromMyWallet];
    }else{
        [self getDiscountCouponData];
    }
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <获取优惠券数据>
-(void)getDiscountCouponData
{
    if (self.shouldPay || kUserDefaultObject(kUserInfo)) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kDiscountCouponList];
        NSDictionary *dictParameter = [NSDictionary dictionary];
        if (self.shouldPay) {
            dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                              @"is_all":@"0",
                              @"total_price":self.shouldPay};
        }else{
            dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                              @"is_all":@"1"};
        }
        
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                MyDiscountCouponModel *model = [[MyDiscountCouponModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
                    [hud hideAnimated:YES afterDelay:1.0];
                    self.couponAvailableArray = model.data.result.available;
                    self.couponUsedArray = model.data.result.used;
                    self.couponExpiredArray = model.data.result.expired;
                    self.couponNormalArray = model.data.result.normal;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
}

#pragma mark - <获取“我的钱包”中查看可用优惠券>
-(void)getAvailableCouponFromMyWallet
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kMyAvailabelCoupon];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                [hud hideAnimated:YES afterDelay:1.0];
                self.couponAvailableArray = dataDict[@"data"][@"result"];
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];

}

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibAvailable = [UINib nibWithNibName:NSStringFromClass([MyDiscountCouponCell class]) bundle:nil];
    [self.tableView registerNib:nibAvailable forCellReuseIdentifier:NSStringFromClass([MyDiscountCouponCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
}











#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.couponAvailableArray.count == 0 && self
        .couponUsedArray.count == 0 && self.couponNormalArray.count == 0 && self.couponExpiredArray.count == 0) {
        return 1;
    }
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.couponAvailableArray.count == 0 && self
        .couponUsedArray.count == 0 && self.couponNormalArray.count == 0 && self.couponExpiredArray.count == 0) {
        return 1;
    }else{
        NSInteger count = 0;
        if (section == 0) {
            count = self.couponAvailableArray.count;
        }else if (section == 1){
            count = self.couponNormalArray.count;
        }else if (section == 2){
            count = self.couponExpiredArray.count;
        }else if (section == 3){
            count = self.couponUsedArray.count;
        }
        return count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.couponAvailableArray.count == 0 && self
        .couponUsedArray.count == 0 && self.couponNormalArray.count == 0 && self.couponExpiredArray.count == 0) {
        NULLTableViewCell *cellNull = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cellNull;
    }
    
    MyDiscountCouponCell *cellCoupon = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyDiscountCouponCell class])];
    if (indexPath.section == 0) {
        MyDiscountCouponAvailableModel *model = self.couponAvailableArray[indexPath.row];
        cellCoupon.modelAvailable = model;
    }else if (indexPath.section == 1){
        MyDiscountCouponNormalModel *model = self.couponNormalArray[indexPath.row];
        cellCoupon.modelNormal = model;
    }else if (indexPath.section == 2){
        MyDiscountCouponExpiredModel *model = self.couponExpiredArray[indexPath.row];
        cellCoupon.modelExpired = model;
    }else if (indexPath.section == 3){
        MyDiscountCouponUsedModel *model = self.couponUsedArray[indexPath.row];
        cellCoupon.modelUsed = model;
    }
    
    return cellCoupon;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.couponAvailableArray.count == 0 && self
        .couponUsedArray.count == 0 && self.couponNormalArray.count == 0 && self.couponExpiredArray.count == 0) {
        return self.view.frame.size.height;
    }else{
        return 120;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (self.shouldPay) {
        MyDiscountCouponAvailableModel *model = self.couponAvailableArray[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectDiscountCoupon" object:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
