//
//  OrderConfirmViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderConfirmViewController.h"

//AliPay
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

//cells
#import "OrderConfirmFeeCell.h"
#import "OrderConfirmAddressCell.h"
#import "OrderConfirmWayOfPayCell.h"
#import "OrderConfirmProductListCell.h"
#import "OrderConfirmDisCountCell.h"

//controllers
#import "MyAddressViewController.h"
#import "ProductDetailViewController.h"
#import "MyDiscountCouponViewController.h"

//models
#import "OrderConfirmModel.h"
#import "OrderConfirmResultModel.h"
#import "OrderConfirmGoodsInfoModel.h"
#import "OrderConfirmUserAddressModel.h"
#import "UserAddressListResultModel.h"
#import "MyDiscountCouponAvailableModel.h"
#import "PlaceOrderModel.h"
#import "PlaceOrderAliPayModel.h"
#import "PlaceOrderWeChatPayModel.h"
#import "PalceOrderOrderInfoModel.h"
#import "PlaceOrderCallbackModel.h"

@interface OrderConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelShouldPay;
@property (nonatomic, strong)NSString *shouldPay;

@property (nonatomic, strong)OrderConfirmGoodsInfoModel *modelGoodsInfo;
@property (nonatomic, strong)OrderConfirmResultModel *modelResult;
@property (nonatomic, strong)OrderConfirmUserAddressModel *modelUserAddress;

@property (nonatomic, strong)NSString *wayOfPay;
@property (nonatomic, strong)NSString *discountCouponID;
@property (nonatomic, strong)NSString *discountPrice;
@property (nonatomic, strong)NSString *discountCouponMessage;

@property (nonatomic, strong)NSMutableArray *specArray;
@property (nonatomic, strong)NSArray *goodsArray;

//支付串码
@property (nonatomic, strong)NSString *pay_code;

@end

@implementation OrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getOrderConfirmData];
    [self settingOutlsets];
    [self settingTableView];
    
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)specArray
{
    if (!_specArray) {
        _specArray = [NSMutableArray array];
    }
    return _specArray;
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
                self.goodsArray = model.data.result.goods_info;
                self.modelGoodsInfo = self.goodsArray[0];
                self.modelResult = model.data.result;
                self.modelUserAddress = model.data.result.user_address;
                
                [self fillDataToOutletsWithModel:self.modelResult];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    //默认选中支付方式第一项
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
                    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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

#pragma mark - <获取立即下单数据_支付宝支付>
-(void)getPlaceOrderDataWithAliPay
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPlaceOrder];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"goods_id":self.modelGoodsInfo.goods_id,
                                    @"goods_num":self.modelGoodsInfo.goods_num,
                                    @"goods_spec":self.specArray,
                                    @"address_id":self.modelUserAddress.address_id,
                                    @"coupon_id":self.discountCouponID,
                                    @"use_money":self.discountPrice,
                                    @"pay_type":self.wayOfPay};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            [hud hideAnimated:YES afterDelay:1.0];
            NSDictionary *dataDict = (NSDictionary *)response;
            NSError *error = nil;
            PlaceOrderModel *model = [[PlaceOrderModel alloc]initWithDictionary:dataDict error:&error];
            if (!error) {
                if ([model.code isEqualToString:@"200"]) {
                    PlaceOrderAliPayModel *modelAliPay = model.data.result.aliPay;
                    self.pay_code = modelAliPay.pay_code;
                    
                    //支付串码不为空就调支付宝
                    if (![self.pay_code isEqualToString:@""]) {
                        NSString *scheme = @"ZhiHuiJia";
                        [[AlipaySDK defaultService]payOrder:self.pay_code fromScheme:scheme callback:^(NSDictionary *resultDic) {
                            NSString *resultStatus = resultDic[@"resultStatus"];
                            if ([resultStatus isEqualToString:@"9000"]) {
                                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"支付成功"];
                                [hudWarning hideAnimated:YES afterDelay:2.0];
                                NSDictionary *dataDict = [self getCallBackDataAfterPayWithResultDict:resultDic];
                                
                            }else{
                                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"支付失败"];
                                [hudWarning hideAnimated:YES afterDelay:2.0];
                            }
                        }];
                    }else{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:2.0];
                    }
                }else{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }
            }
            
        }else{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请稍后再试"];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}

#pragma mark - <获取立即下单数据_微信支付>
-(void)getPlaceOrderDataWithWeChatPay
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPlaceOrder];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"goods_id":self.modelGoodsInfo.goods_id,
                                    @"goods_num":self.modelGoodsInfo.goods_num,
                                    @"goods_spec":self.specArray,
                                    @"address_id":self.modelUserAddress.address_id,
                                    @"coupon_id":self.discountCouponID,
                                    @"use_money":self.discountPrice,
                                    @"pay_type":@"2"};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            PlaceOrderModel *model = [[PlaceOrderModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                [hud hideAnimated:YES afterDelay:1.0];
                PlaceOrderCallbackModel *modelCallback = model.data.result.wxPay.callback;
                PalceOrderOrderInfoModel *modelOrderInfo = model.data.result.wxPay.order_info;
                
                PayReq *payreq = [[PayReq alloc]init];
                payreq.partnerId = modelCallback.partnerid;
                payreq.package = modelCallback.package;
                payreq.prepayId = modelCallback.prepayid;
                payreq.sign = modelCallback.sign;
                payreq.timeStamp = (UInt32)[modelCallback.timestamp intValue];
                payreq.nonceStr = modelCallback.noncestr;
                if (![WXApi isWXAppInstalled]) {
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请安装微信"];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }else if (![WXApi isWXAppSupportApi]){
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"不支持微信支付"];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                }else{
                    [WXApi sendReq:payreq];
                }
                
            }else{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}

#pragma mark - <获取支付回调的数据>
-(NSDictionary *)getCallBackDataAfterPayWithResultDict:(NSDictionary *)resultDict
{
    NSDictionary *result = resultDict[@"result"];
    NSDictionary *dataDict = result[@"alipay_trade_app_pay_response"];
    return dataDict;
}


#pragma mark - <填充数据给outlets>
-(void)fillDataToOutletsWithModel:(OrderConfirmResultModel *)model;
{
    self.labelShouldPay.text = [NSString stringWithFormat:@"¥%@",model.unpaid];
    self.shouldPay = model.unpaid;
    
    float shouldPay = [self.shouldPay floatValue];
    if (shouldPay>0) {
        self.wayOfPay = @"1";
    }
}

#pragma mark - <设定默认outlets>
-(void)settingOutlsets
{
    self.wayOfPay = @"0";
    self.discountCouponID = @"0";
    self.discountCouponMessage = @"分享产品立即满减";
    self.discountPrice = @"0";
    self.specArray = [self.Parameter objectForKey:@"goods_spec"];
    self.goods_num = [self.Parameter objectForKey:@"goods_num"];
    self.goods_id = [self.Parameter objectForKey:@"goods_id"];

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
    float shouldPay = [self.shouldPay floatValue];
    if (shouldPay > 0 && [self.wayOfPay isEqualToString:@"0"]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请选择支付方式"];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else if (shouldPay > 0 && ![self.wayOfPay isEqualToString:@"0"]){
        if ([self.wayOfPay isEqualToString:@"1"]) {
            //获取支付串码_支付宝支付
            [self getPlaceOrderDataWithAliPay];
        }else{
            //微信支付
            [self getPlaceOrderDataWithWeChatPay];
        }
    }else{
        //跳转支付成功页面
    }
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
-(void)jumpToDiscountVCWithShouldPay:(NSString *)shouldPay
{
    MyDiscountCouponViewController *discountVC = [[MyDiscountCouponViewController alloc]initWithNibName:NSStringFromClass([MyDiscountCouponViewController class]) bundle:nil];
    discountVC.shouldPay = shouldPay;
    discountVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:discountVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //选择收货地址
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
    
    //选择优惠券
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectDiscountCoupon" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        MyDiscountCouponAvailableModel *model = x.object;
        self.discountCouponMessage = [NSString stringWithFormat:@"已选择%@优惠券",model.money];
        self.discountCouponID = model.id;
        self.discountPrice = model.money;
        //计算应支付：应支付-优惠券
        float discountPrice = [self.discountPrice floatValue];
        float shouldPay = [self.shouldPay floatValue];
        shouldPay = shouldPay-discountPrice;
        if (shouldPay < 0) {
            shouldPay = 0.00;
        }
        self.labelShouldPay.text = [NSString stringWithFormat:@"¥%.2f",shouldPay];
        [self.tableView reloadData];
    }];
}









#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    float shouldPay = [self.shouldPay floatValue];
    if (shouldPay>0) {
        return 5;
    }
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.goodsArray.count;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 1;
    }else if (section == 4){
        return 2;
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
        OrderConfirmGoodsInfoModel *model = self.goodsArray[indexPath.row];
        cellProductList.modelGoodsInfo = model;
        cell = cellProductList;
    }else if (indexPath.section == 2){
        OrderConfirmDisCountCell *cellDiscount = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmDisCountCell class])];
        cellDiscount.labelDiscountMessage.text = self.discountCouponMessage;
        cell = cellDiscount;
    }else if (indexPath.section == 3){
        OrderConfirmFeeCell  *cellFee = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmFeeCell class])];
        cellFee.labelTotalPrice.text = [NSString stringWithFormat:@"¥%@",self.modelResult.total_price];
        cellFee.labelFreight.text = [NSString stringWithFormat:@"¥%@",self.modelResult.freight];
        cellFee.labelDiscount.text = [NSString stringWithFormat:@"-¥%@",self.discountPrice];
        cellFee.labelUserBalance.text = [NSString stringWithFormat:@"-¥%@",self.modelResult.use_money];
        cell = cellFee;
    }else if (indexPath.section == 4){
        OrderConfirmWayOfPayCell *cellWayOfPay = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmWayOfPayCell class])];
//        cellWayOfPay.wayOfPay = self.wayOfPay;
        cellWayOfPay.tag = indexPath.row;
        if (indexPath.row == 0) {cellWayOfPay.imgWayOfPay.image = [UIImage imageNamed:@"zhi_fu_bao_zhi_fu"];
            cellWayOfPay.labelWayOfPay.text = @"支付宝";
        }else if (indexPath.row == 1){
            cellWayOfPay.imgWayOfPay.image = [UIImage imageNamed:@"wei_xin_zhi_fu"];
            cellWayOfPay.labelWayOfPay.text = @"微信支付";
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
        OrderConfirmGoodsInfoModel *model = self.goodsArray[indexPath.row];
        [self jumpToProductDetailVCWithGoodsID:model.goods_id];
    }else if (indexPath.section == 2){
        double totalPrice = [self.modelResult.total_price doubleValue];
        double freight = [self.modelResult.freight doubleValue];
        NSString *shouldPay = [NSString stringWithFormat:@"%f",totalPrice+freight];
        [self jumpToDiscountVCWithShouldPay:shouldPay];
    }else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            self.wayOfPay = @"1";//支付宝
        }else if (indexPath.row == 1){
            self.wayOfPay = @"2";//微信支付
        }
    }
}



@end
