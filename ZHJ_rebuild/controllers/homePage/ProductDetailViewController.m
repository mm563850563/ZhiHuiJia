//
//  ProductDetailViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductDetailViewController.h"

//views
#import "ProductDetailHeaderView.h"
#import "BuyNowSelectSpecView.h"

//controllers
#import "CommentListViewController.h"
#import "OrderConfirmViewController.h"

//cells
#import "ProductDetailImageCell.h"

//models
#import "GoodsDetailModel.h"
#import "GoodsDetailImageModel.h"
#import "GoodsDetailContentModel.h"
#import "GoodsDetailGoodsInfoModel.h"
#import "AddToCollectionModel.h"

@interface ProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCollection;

@property (nonatomic, strong)UIView *cloudGlassBGView;
@property (nonatomic, strong)BuyNowSelectSpecView *productMessageAndBuyNowView;

@property (nonatomic, strong)GoodsDetailGoodsInfoModel *modelInfo;
@property (nonatomic, strong)NSMutableArray *bannerArray;
@property (nonatomic, strong)NSArray *contentArray;
@property (nonatomic, strong)NSArray *spec_listArray;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getGoodsDetailData];
    [self settingTableView];
    [self initProductMessageView];
    
    [self respondWithRAC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <获取商品详情数据>
-(void)getGoodsDetailData
{
    if (self.goods_id) {
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        NSDictionary *dictParameter = @{@"goods_id":self.goods_id};
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGoodsDetail];
        [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            [hud hideAnimated:YES afterDelay:1.0];
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                GoodsDetailModel *model = [[GoodsDetailModel alloc]initWithDictionary:dataDict error:nil];
                
                if ([model.code isEqualToString:@"200"]) {
                    self.modelInfo = model.data.result.goods_info;
                    self.contentArray = model.data.result.goods_content;
                    self.spec_listArray = model.data.result.spec_list;
                    
                    //传数据给“立即购买选择规格”view(下面两句不能调换)
                    self.productMessageAndBuyNowView.goods_id = self.modelInfo.goods_id;
                    self.productMessageAndBuyNowView.dataArray = self.spec_listArray;
                    
                    //判断是否已经收藏
                    if ([model.data.result.is_collected isEqualToString:@"0"]) {
                        self.imgViewCollection.image = [UIImage imageNamed:@"kefu"];
                    }else{
                        self.imgViewCollection.image = [UIImage imageNamed:@"shouc"];
                    }
                    
                    for (GoodsDetailImageModel *modelImage in model.data.result.goods_images) {
                        NSString *str = [NSString stringWithFormat:@"%@%@",kDomainImage,modelImage.image_url];
                        [self.bannerArray addObject:str];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:2.0];
                    });
                }
            }
        } failBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }];
    }
}

#pragma mark - <获取添加到收藏数据>
-(void)getAddToCollectionData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kAddToCollection];
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (kUserDefaultObject(kUserInfo) || ![self.goods_id isEqualToString:@""]) {
        dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                          @"goods_id":self.goods_id};
    }
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            AddToCollectionModel *model = [[AddToCollectionModel alloc]initWithDictionary:dataDict error:nil];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
            [hudWarning hideAnimated:YES afterDelay:2.0];
            if ([model.code isEqualToString:@"200"]) {
                self.imgViewCollection.image = [UIImage imageNamed:@"shouc"];
            }
        }
    } failBlock:^(NSError *error) {
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:error.description];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}


#pragma mark - <获取删除收藏数据>
-(void)getDeleteCollectionData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kDeleteCollection];
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (kUserDefaultObject(kUserInfo) || ![self.goods_id isEqualToString:@""]) {
        dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                          @"goods_id":self.goods_id};
    }
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            AddToCollectionModel *model = [[AddToCollectionModel alloc]initWithDictionary:dataDict error:nil];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
            [hudWarning hideAnimated:YES afterDelay:2.0];
            if ([model.code isEqualToString:@"200"]) {
                self.imgViewCollection.image = [UIImage imageNamed:@"kefu"];
            }
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
//    self.tableView.estimatedRowHeight = 200;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProductDetailImageCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([ProductDetailImageCell class])];
}

#pragma mark - <跳转查看更多评论页面>
-(void)jumpToMoreCommentVC
{
    CommentListViewController *commentListVC = [[CommentListViewController alloc]initWithNibName:NSStringFromClass([CommentListViewController class]) bundle:nil];
    [self.navigationController pushViewController:commentListVC animated:YES];
}

#pragma mark - <跳转确认订单页面>
-(void)jumpToOrderConfirmVCWithParameter:(NSDictionary *)dictParameter
{
    OrderConfirmViewController *orderConfirmVC = [[OrderConfirmViewController alloc]initWithNibName:NSStringFromClass([OrderConfirmViewController class]) bundle:nil];
    orderConfirmVC.Parameter = dictParameter;
    orderConfirmVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}

#pragma mark - <客服>
- (IBAction)btnSalesCenterAction:(UIButton *)sender
{
    
}

#pragma mark - <店铺>
- (IBAction)btnStoreAction:(UIButton *)sender
{
    
}

#pragma mark - <收藏>
- (IBAction)btnCollectionAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self getAddToCollectionData];
    }else{
        [self getDeleteCollectionData];
    }
    
}

#pragma mark - <加入购物车>
- (IBAction)btnAddToCartAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popProductMessageView" object:nil];
}

#pragma mark - <立即购买>
- (IBAction)btnBuyByNowAction:(UIButton *)sender
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.cloudGlassBGView];
    [UIView animateWithDuration:0.3 animations:^{
        self.productMessageAndBuyNowView.frame = CGRectMake(0, kSCREENH_HEIGHT-400, kSCREEN_WIDTH, 400);
    }];
}

#pragma mark - <初始化商品规格选择页面>
-(void)initProductMessageView
{
    self.cloudGlassBGView = [[UIView alloc]initWithFrame:kScreeFrame];
    self.cloudGlassBGView.backgroundColor = kColorFromRGBAndAlpha(kBlack, 0.4);
    
    self.productMessageAndBuyNowView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BuyNowSelectSpecView class]) owner:nil options:nil].lastObject;
    self.productMessageAndBuyNowView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 400);
    [self.cloudGlassBGView addSubview:self.productMessageAndBuyNowView];
}


#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"JumpToMoreCommentVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMoreCommentVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"removeBuyNowSpecView" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.productMessageAndBuyNowView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 400);
        } completion:^(BOOL finished) {
            [self.cloudGlassBGView removeFromSuperview];
        }];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToOrderConfirmVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dictParameter = x.object;
        [self jumpToOrderConfirmVCWithParameter:dictParameter];
    }];
}




















#pragma mark - <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailContentModel *model = self.contentArray[indexPath.row];
    ProductDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductDetailImageCell class])];
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSCREEN_WIDTH+315;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ProductDetailHeaderView *headerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ProductDetailHeaderView class]) owner:nil options:nil].lastObject;
    headerView.bannerArray = self.bannerArray;
    headerView.modelInfo = self.modelInfo;
    headerView.spec_listArray = self.spec_listArray;
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailContentModel *model = self.contentArray[indexPath.row];
    ProductDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductDetailImageCell class])];
    cell.model = model;
    return cell.cellHeight;
}


@end
