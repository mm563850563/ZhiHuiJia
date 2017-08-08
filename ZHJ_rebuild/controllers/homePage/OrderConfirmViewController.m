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

@interface OrderConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalPrice;

@end

@implementation OrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        return 3;
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
        cell = cellAddress;
    }else if (indexPath.section == 1){
        OrderConfirmProductListCell *cellProductList = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmProductListCell class])];
        cell = cellProductList;
    }else if (indexPath.section == 2){
        OrderConfirmDisCountCell *cellDiscount = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmDisCountCell class])];
        cell = cellDiscount;
    }else if (indexPath.section == 3){
        OrderConfirmFeeCell  *cellFee = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmFeeCell class])];
        cell = cellFee;
    }else if (indexPath.section == 4){
        OrderConfirmWayOfPayCell *cellWayOfPay = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderConfirmWayOfPayCell class])];
        cell = cellWayOfPay;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self jumpToAddressListVC];
    }
}



@end
