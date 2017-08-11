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

//models
#import "MyDiscountCouponModel.h"
#import "MyDiscountCouponAvailableModel.h"

@interface MyDiscountCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *couponAvailableArray;

@end

@implementation MyDiscountCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getDiscountCouponData];
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
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                        @"is_all":@"0",
                                        @"total_price":self.shouldPay};
        
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                MyDiscountCouponModel *model = [[MyDiscountCouponModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
                    [hud hideAnimated:YES afterDelay:1.0];
                    self.couponAvailableArray = model.data.result.available;
                    
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
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"数据为空"];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        } failBlock:^(NSError *error) {
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }];
    }
    
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
}











#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponAvailableArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    MyDiscountCouponCell *cellAvailable = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyDiscountCouponCell class])];
    MyDiscountCouponAvailableModel *model = self.couponAvailableArray[indexPath.row];
    cellAvailable.modelAvailable = model;
    cell = cellAvailable;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    MyDiscountCouponAvailableModel *model = self.couponAvailableArray[indexPath.row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectDiscountCoupon" object:model];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
