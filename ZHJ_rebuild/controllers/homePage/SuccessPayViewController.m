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

@interface SuccessPayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    
    
    [self settingTableView];
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
        return 100.0f;
    }
    return 0.1f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        SuccessPayTableViewCell *successPayCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SuccessPayTableViewCell class])];
        if (indexPath.row == 0) {
            successPayCell.labelItemName.text = @"订单编号：";
            successPayCell.labelItemValue.text = self.order_sn;
        }else if (indexPath.row == 1){
            successPayCell.labelItemName.text = @"交易金额：";
            successPayCell.labelItemValue.text = [NSString stringWithFormat:@"¥%@",self.payables];
        }else if (indexPath.row == 2){
            successPayCell.labelItemName.text = @"用户余额：";
            successPayCell.labelItemValue.text = [NSString stringWithFormat:@"-¥%@",self.use_money];
        }else if (indexPath.row == 3){
            successPayCell.labelItemName.text = @"优惠金额：";
            successPayCell.labelItemValue.text = [NSString stringWithFormat:@"-¥%@",self.coupon_price];
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
        cell = successPayRecommedCell;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 35.0f;
    }else if (indexPath.section == 1){
        return 200.0f;
    }
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}







@end
