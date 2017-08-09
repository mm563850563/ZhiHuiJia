//
//  OrderConfirmViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderConfirmViewController.h"

//cells
#import "OrderConfirmFeeCell.h"
#import "OrderConfirmAddressCell.h"
#import "OrderConfirmWayOfPayCell.h"
#import "OrderConfirmProductListCell.h"
#import "OrderConfirmDisCountCell.h"

//controllers
#import "MyAddressViewController.h"
#import "ProductDetailViewController.h"
#import "SubNotification_DiscountViewController.h"

//models
#import "OrderConfirmModel.h"
#import "OrderConfirmResultModel.h"
#import "OrderConfirmGoodsInfoModel.h"
#import "OrderConfirmUserAddressModel.h"
#import "UserAddressListResultModel.h"

@interface OrderConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;

@property (nonatomic, strong)OrderConfirmGoodsInfoModel *modelGoodsInfo;
@property (nonatomic, strong)OrderConfirmResultModel *modelResult;
@property (nonatomic, strong)OrderConfirmUserAddressModel *modelUserAddress;

@end

@implementation OrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getOrderConfirmData];
    [self settingTableView];
    
    [self respondWithRAC];
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

#pragma mark - <获取订单数据>
-(void)getOrderConfirmData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kConfirmOrder];
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:self.Parameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            OrderConfirmModel *model = [[OrderConfirmModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                [hud hideAnimated:YES afterDelay:1.0];
                self.modelGoodsInfo = model.data.result.goods_info;
                self.modelResult = model.data.result;
                self.modelUserAddress = model.data.result.user_address;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] animated:YES scrollPosition:UITableViewScrollPositionNone];
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

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibAddress = [UINib nibWithNibName:NSStringFromClass([OrderConfirmAddressCell class]) bundle:nil];
    UINib *nibProductList = [UINib nibWithNibName:NSStringFromClass([OrderConfirmProductListCell class]) bundle:nil];
    UINib *nibDiscount = [UINib nibWithNibName:NSStringFromClass([OrderConfirmDisCountCell class]) bundle:nil];
    UINib *nibFee = [UINib nibWithNibName:NSStringFromClass([OrderConfirmFeeCell class]) bundle:nil];
    UINib *nibWayOfPay = [UINib nibWithNibName:NSStringFromClass([OrderConfirmWayOfPayCell class]) bundle:nil];
    
    [self.tableView registerNib:nibFee forCellReuseIdentifier:NSStringFromClass([OrderConfirmFeeCell class])];
    [self.tableView registerNib:nibDiscount forCellReuseIdentifier:NSStringFromClass([OrderConfirmDisCountCell class])];
    [self.tableView registerNib:nibAddress forCellReuseIdentifier:NSStringFromClass([OrderConfirmAddressCell class])];
    [self.tableView registerNib:nibWayOfPay forCellReuseIdentifier:NSStringFromClass([OrderConfirmWayOfPayCell class])];
    [self.tableView registerNib:nibProductList forCellReuseIdentifier:NSStringFromClass([OrderConfirmProductListCell class])];
}

#pragma mark - <立即下单按钮响应>
- (IBAction)btnConfirmOrderNowAction:(UIButton *)sender
{
    
}

#pragma mark - <跳转用户地址列表页面>
-(void)jumpToAddressListVC
{
    MyAddressViewController *myAddressListVC = [[MyAddressViewController alloc]initWithNibName:NSStringFromClass([MyAddressViewController class]) bundle:nil];
    myAddressListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myAddressListVC animated:YES];
}

#pragma mark - <跳转产品详情页面>
-(void)jumpToProductDetailVCWithGoodsID:(NSString *)goods_id
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    productDetailVC.goods_id = goods_id;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

#pragma mark - <跳转优惠券页面>
-(void)jumpToDiscountVC
{
    SubNotification_DiscountViewController *discountVC = [[SubNotification_DiscountViewController alloc]initWithNibName:NSStringFromClass([SubNotification_DiscountViewController class]) bundle:nil];
    discountVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:discountVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectAddress" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UserAddressListResultModel *model = x.object;
        
        self.modelUserAddress.consignee = model.consignee;
        self.modelUserAddress.mobile = model.mobile;
        self.modelUserAddress.area = model.area;
        self.modelUserAddress.address = model.address;
        self.modelUserAddress.address_id = model.address_id;
        self.modelUserAddress.is_default = model.is_default;
        self.modelUserAddress.province = model.province;
        self.modelUserAddress.city = model.city;
        self.modelUserAddress.district = model.district;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}









#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 1;
    }else if (section == 4){
        return 3;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100.0f;
    }else if (indexPath.section == 1){
        return 100.0f;
    }else if (indexPath.section == 2){
        return 50.0f;
    }else if (indexPath.section == 3){
        return 120.0f;
    }else if (indexPath.section == 4){
        return 40.0f;
    }
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 0.1f;
    }else if (section == 2){
        return 0.1f;
    }else if (section == 3){
        return 0.1f;
    }
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        OrderConfirmAddressCell *cellAddress = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmAddressCell class])];
        cellAddress.modelUserAddress = self.modelUserAddress;
        cell = cellAddress;
    }else if (indexPath.section == 1){
        OrderConfirmProductListCell *cellProductList = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmProductListCell class])];
        cellProductList.modelGoodsInfo = self.modelGoodsInfo;
        cell = cellProductList;
    }else if (indexPath.section == 2){
        OrderConfirmDisCountCell *cellDiscount = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmDisCountCell class])];
        cell = cellDiscount;
    }else if (indexPath.section == 3){
        OrderConfirmFeeCell  *cellFee = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmFeeCell class])];
        cellFee.labelTotalPrice.text = [NSString stringWithFormat:@"¥%@",self.modelGoodsInfo.price];
        cellFee.labelFreight.text = [NSString stringWithFormat:@"¥%@",self.modelGoodsInfo.freight];
        cellFee.labelDiscount.text = [NSString stringWithFormat:@"-¥%@",@"0"];
        cell = cellFee;
    }else if (indexPath.section == 4){
        OrderConfirmWayOfPayCell *cellWayOfPay = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmWayOfPayCell class])];
        if (indexPath.row == 0) {
            cellWayOfPay.imgWayOfPay.image = [UIImage imageNamed:@"wei_xin_zhi_fu"];
            cellWayOfPay.labelWayOfPay.text = @"微信支付";
        }else if (indexPath.row == 1){
            cellWayOfPay.imgWayOfPay.image = [UIImage imageNamed:@"zhi_fu_bao_zhi_fu"];
            cellWayOfPay.labelWayOfPay.text = @"支付宝";
        }else if (indexPath.row == 2){
            cellWayOfPay.imgWayOfPay.image = [UIImage imageNamed:@"zj"];
            cellWayOfPay.labelWayOfPay.text = @"用户余额";
        }
        cell = cellWayOfPay;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self jumpToAddressListVC];
        }
    }else if (indexPath.section == 1){
        [self jumpToProductDetailVCWithGoodsID:self.modelGoodsInfo.goods_id];
    }else if (indexPath.section == 2){
        [self jumpToDiscountVC];
    }
}



@end