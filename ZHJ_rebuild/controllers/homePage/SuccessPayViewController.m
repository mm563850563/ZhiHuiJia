//
//  SuccessPayViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SuccessPayViewController.h"

//views
#import "SuccessPayHeaderView.h"
#import "SuccessPayRecommedHeaderView.h"

//cells
#import "SuccessPayTableViewCell.h"
#import "SuccessPayRecommedCell.h"

//models
#import "GetInterestingCircleDataModel.h"
#import "GetInterestingCircleResultModel.h"

@interface SuccessPayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *interestingCircleArray;

@property (nonatomic, strong)NSString *payables;
@property (nonatomic, strong)NSString *order_sn;
@property (nonatomic, strong)NSString *use_money;
@property (nonatomic, strong)NSString *coupon_price;
@property (nonatomic, strong)NSString *add_time;

@end

@implementation SuccessPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getInterestingCircleData];
    [self settingTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSArray *)interestingCircleArray
{
    if (!_interestingCircleArray) {
        _interestingCircleArray = [NSArray array];
    }
    return _interestingCircleArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取感兴趣的圈子>
-(void)getInterestingCircleData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetInterestedCircle];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = dataDict[@"code"];
            
            if ([code isEqual:@200]) {
                GetInterestingCircleDataModel *modelData = [[GetInterestingCircleDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.interestingCircleArray = modelData.result;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    }];
}

-(void)setModelWX:(PalceOrderOrderInfoModel *)modelWX
{
    self.order_sn = modelWX.order_sn;
    self.payables = modelWX.payables;
    self.use_money = modelWX.use_money;
    self.coupon_price = modelWX.coupon_price;
    self.add_time = modelWX.add_time;
}

-(void)setModelAli:(PlaceOrderAliPayModel *)modelAli
{
    self.order_sn = modelAli.order_sn;
    self.payables = modelAli.payables;
    self.use_money = modelAli.use_money;
    self.coupon_price = modelAli.coupon_price;
    self.add_time = modelAli.add_time;
}

-(void)setModelBlance:(PlaceOrderBalanceModel *)modelBlance
{
    self.order_sn = modelBlance.order_sn;
    self.payables = modelBlance.payables;
    self.use_money = modelBlance.use_money;
    self.coupon_price = modelBlance.coupon_price;
    self.add_time = modelBlance.add_time;
}

-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.rowHeight =
    
    UINib *nibSuccessPay = [UINib nibWithNibName:NSStringFromClass([SuccessPayTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibSuccessPay forCellReuseIdentifier:NSStringFromClass([SuccessPayTableViewCell class])];
    
    [self.tableView registerClass:[SuccessPayRecommedCell class] forCellReuseIdentifier:NSStringFromClass([SuccessPayRecommedCell class])];
    
}

- (IBAction)btnBackAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:NO];
}








#pragma mark - ******** UITableViewDelegate, UITableViewDataSource ********
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    if (section == 0) {
        SuccessPayHeaderView *sucedPayHeaderView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SuccessPayHeaderView class]) owner:nil options:nil].lastObject;
        headerView = sucedPayHeaderView;
    }else if (section == 1){
        SuccessPayRecommedHeaderView *recommedHeaderView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SuccessPayRecommedHeaderView class]) owner:nil options:nil].lastObject;
        headerView = recommedHeaderView;
    }
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 80.0f;
    }else if (section == 1){
        return 60.0f;
    }
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        SuccessPayTableViewCell *successPayCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SuccessPayTableViewCell class])];
        if (indexPath.row == 0) {
            successPayCell.labelItemName.text = @"订单编号：";
            if (self.order_sn) {
                successPayCell.labelItemValue.text = self.order_sn;
            }
            
        }else if (indexPath.row == 1){
            successPayCell.labelItemName.text = @"交易金额：";
            if (self.payables) {
                successPayCell.labelItemValue.text = [NSString stringWithFormat:@"¥%@",self.payables];
            }else{
                successPayCell.labelItemValue.text = [NSString stringWithFormat:@"¥%@",@"0"];
            }
            
        }else if (indexPath.row == 2){
            successPayCell.labelItemName.text = @"用户余额：";
            if (self.use_money) {
                successPayCell.labelItemValue.text = [NSString stringWithFormat:@"-¥%@",self.use_money];
            }else{
                successPayCell.labelItemValue.text = [NSString stringWithFormat:@"-¥%@",@"0"];
            }
            
        }else if (indexPath.row == 3){
            successPayCell.labelItemName.text = @"优惠金额：";
            if (self.coupon_price) {
                successPayCell.labelItemValue.text = [NSString stringWithFormat:@"-¥%@",self.coupon_price];
            }else{
                successPayCell.labelItemValue.text = [NSString stringWithFormat:@"-¥%@",@"0"];
            }
            
        }else if (indexPath.row == 4){
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSTimeInterval time = [self.add_time doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSString *strDate = [formatter stringFromDate:date];
            successPayCell.labelItemValue.text = [NSString stringWithFormat:@"%@",strDate];
            successPayCell.labelItemName.text = @"交易时间：";
        }
        cell = successPayCell;
    }else if (indexPath.section == 1){
        SuccessPayRecommedCell *successPayRecommedCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SuccessPayRecommedCell class])];
        successPayRecommedCell.interestingCircleArray = self.interestingCircleArray;
        cell = successPayRecommedCell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 35.0f;
    }else if (indexPath.section == 1){
        SuccessPayRecommedCell *cell = [[SuccessPayRecommedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([SuccessPayRecommedCell class])];
        cell.interestingCircleArray = self.interestingCircleArray;
        return cell.cellHeight;
    }
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}







@end
