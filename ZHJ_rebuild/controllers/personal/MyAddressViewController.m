//
//  MyAddressViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyAddressViewController.h"

//cells
#import "MyAddressCell.h"

//controllers
#import "MyAddressIncreaseViewController.h"
#import "EditMyAddressViewController.h"

//models
#import "UserAddressListModel.h"
#import "UserAddressListResultModel.h"

@interface MyAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *addressListArray;

@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getUserAddressListData];
    [self settingTableview];
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

#pragma mark - <获取用户地址列表数据>
-(void)getUserAddressListData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUserAddressList];
    if (kUserDefaultObject(kUserInfo)) {
        NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                UserAddressListModel *model = [[UserAddressListModel alloc]initWithDictionary:dataDict error:nil];
                if ([model.code isEqualToString:@"200"]) {
                    [hud hideAnimated:YES afterDelay:1.0];
                    self.addressListArray = [NSMutableArray arrayWithArray:model.data.result];
                    
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

#pragma mark - <获取设置默认收货地址数据>
-(void)getSetDefaultAddressDataWithUserID:(NSString *)user_id addressID:(NSString *)address_id
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSetDefaultAddress];
    NSDictionary *dictParameter = @{@"user_id":user_id,
                                    @"address_id":address_id};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        NSDictionary *dataDict = (NSDictionary *)response;
        NSNumber *code = (NSNumber *)dataDict[@"code"];
        if ([code isEqual:@200]) {
            //设置成功后重新请求页面数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getUserAddressListData];
            });
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }else{
            
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
    }];
}

#pragma mark - <获取删除收货地址数据>
-(void)getDeleteAddressDataWithUserID:(NSString *)user_id addressID:(NSString *)address_id
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kDeleteAddress];
    NSDictionary *dictParameter = @{@"user_id":user_id,
                                    @"address_id":address_id};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        NSDictionary *dataDict = (NSDictionary *)response;
        NSNumber *code = (NSNumber *)dataDict[@"code"];
        if ([code isEqual:@200]) {
            //设置成功后重新请求页面数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getUserAddressListData];
            });
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }else{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
    }];
}

#pragma mark - <配置tableView>
-(void)settingTableview
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([MyAddressCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MyAddressCell class])];
}

#pragma mark - <新增地址>
- (IBAction)btnIncreaseNewlyAddress:(id)sender
{
    MyAddressIncreaseViewController *myAddressIncreaseVC = [[MyAddressIncreaseViewController alloc]initWithNibName:NSStringFromClass([MyAddressIncreaseViewController class]) bundle:nil];
    [self.navigationController pushViewController:myAddressIncreaseVC animated:YES];
}

#pragma mark - <跳转编辑地址页面>
-(void)jumpToEditMyAddressVCWithModel:(UserAddressListResultModel *)model
{
    EditMyAddressViewController *editMyAddressVC = [[EditMyAddressViewController alloc]initWithNibName:NSStringFromClass([EditMyAddressViewController class]) bundle:nil];
    editMyAddressVC.model = model;
    editMyAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editMyAddressVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //编辑地址
    [[[NSNotificationCenter defaultCenter ]rac_addObserverForName:@"EditAddressAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        UserAddressListResultModel *model = x.object;
        [self jumpToEditMyAddressVCWithModel:model];
    }];
    
    //编辑地址后刷新该页面
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"submitAfterModifyAddress" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self getUserAddressListData];
    }];
    
    //删除地址
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DeleteAddressAction" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *address_id = x.object;
        NSString *user_id = kUserDefaultObject( kUserInfo);
        [self getDeleteAddressDataWithUserID:user_id addressID:address_id];
    }];
    
    //选择收货地址
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"selectAddress" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //设置默认收货地址
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"setDefaultAddress" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *address_id = x.object;
        NSString *user_id = kUserDefaultObject( kUserInfo);
        [self getSetDefaultAddressDataWithUserID:user_id addressID:address_id];
    }];
}












#pragma mark - *** UItableViewDelegate,UITableViewDataSource  ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyAddressCell class])];
    UserAddressListResultModel *model = self.addressListArray[indexPath.row];
    cell.btnEdit.tag = indexPath.row;
    cell.btnDelete.tag = indexPath.row;
    cell.modelResult = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
