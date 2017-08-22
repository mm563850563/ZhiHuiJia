//
//  MyTrackViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyTrackViewController.h"

//cells
#import "MyTrackTableViewCell.h"
#import "NULLTableViewCell.h"

//views
#import "MyTrackHeaderView.h"

//models
#import "MyTrackDataModel.h"
#import "MyTrackResultModel.h"
#import "MyTrackGoodsInfoModel.h"

//controllers
#import "ProductDetailViewController.h"

@interface MyTrackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *myTrackResultArray;

@end

@implementation MyTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getMyTrackData];
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

#pragma mark - <获取“足迹”数据>
-(void)getMyTrackData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kMyTrack];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                MyTrackDataModel *modelData = [[MyTrackDataModel alloc]initWithDictionary:dataDict[@"data"] error:nil];
                self.myTrackResultArray = modelData.result;
                
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <跳转产品详情页面>
-(void)jumpToProductDetailVCWithGoodsID:(NSString *)goods_id
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    productDetailVC.hidesBottomBarWhenPushed = YES;
    productDetailVC.goods_id = goods_id;
    [self.navigationController pushViewController:productDetailVC animated:YES];
}

#pragma mark - <tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([MyTrackTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([MyTrackTableViewCell class])];
    
    UINib *nibNull = [UINib nibWithNibName:NSStringFromClass([NULLTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nibNull forCellReuseIdentifier:NSStringFromClass([NULLTableViewCell class])];
    
}











#pragma mark - **** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.myTrackResultArray.count == 0) {
        return 1;
    }
    return self.myTrackResultArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.myTrackResultArray.count > 0) {
        MyTrackResultModel *modelReuslt = self.myTrackResultArray[section];
        NSArray *array = modelReuslt.goods_info;
        return array.count;
    }else{
        return 1;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.myTrackResultArray.count > 0) {
        return 40;
    }
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myTrackResultArray.count > 0) {
        return 100;
    }else{
        return self.view.frame.size.height;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.myTrackResultArray.count > 0) {
        MyTrackHeaderView *headerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MyTrackHeaderView class]) owner:nil options:nil].lastObject;
        MyTrackResultModel *modelResult = self.myTrackResultArray[section];
        headerView.labelDate.text = modelResult.date;
        return headerView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myTrackResultArray.count > 0) {
        MyTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTrackTableViewCell class])];
        MyTrackResultModel *modelResult = self.myTrackResultArray[indexPath.section];
        NSArray *array = modelResult.goods_info;
        MyTrackGoodsInfoModel *modelGoodsInfo = array[indexPath.row];
        cell.modelMyTrackGoodsInfo = modelGoodsInfo;
        return cell;
    }else{
        NULLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NULLTableViewCell class])];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myTrackResultArray.count>0) {
        MyTrackResultModel *modelResult = self.myTrackResultArray[indexPath.section];
        NSArray *array = modelResult.goods_info;
        MyTrackGoodsInfoModel *modelGoodsInfo = array[indexPath.row];
        [self jumpToProductDetailVCWithGoodsID:modelGoodsInfo.goods_id];
    }
    
}



@end
