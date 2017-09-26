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
#import "ProductColorAndCountView.h"

//controllers
#import "CommentListViewController.h"
#import "OrderConfirmViewController.h"
#import "MyOrderViewController.h"

//cells
#import "ProductDetailImageCell.h"

//models
#import "GoodsDetailModel.h"
#import "GoodsDetailImageModel.h"
#import "GoodsDetailContentModel.h"
#import "GoodsDetailGoodsInfoModel.h"
#import "AddToCollectionModel.h"

//tools
#import "ShareTool.h"

//SDKs
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

//IM
#import "EaseUI.h"
#import "ZHJMessageViewController.h"

@interface ProductDetailViewController ()<UITableViewDelegate,UITableViewDataSource,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCollection;

@property (nonatomic, strong)UIView *cloudGlassBGView;
@property (nonatomic, strong)UIView *cloudGlassBGView2;
@property (nonatomic, strong)BuyNowSelectSpecView *productMessageAndBuyNowView;
@property (nonatomic, strong)ProductColorAndCountView *productMessageAddToCartView;

@property (nonatomic, strong)GoodsDetailGoodsInfoModel *modelInfo;
@property (nonatomic, strong)NSMutableArray *bannerArray;
@property (nonatomic, strong)NSArray *contentArray;
@property (nonatomic, strong)NSArray *spec_listArray;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self userBrowseGoods];
    [self getGoodsDetailData];
    [self settingNavigation];
    [self settingTableView];
//    [self initBuyNowProductMessageView];
//    [self initAddToCartProductMessageView];
    
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

#pragma mark - <设置navigation>
-(void)settingNavigation
{
    self.navigationItem.title = @"商品详情概述";
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    btnShare.frame = CGRectMake(0, 0, 25, 25);
    [btnShare addTarget:self action:@selector(settingShareParameter) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnBarShare = [[UIBarButtonItem alloc]initWithCustomView:btnShare];
    self.navigationItem.rightBarButtonItem = btnBarShare;
}

#pragma mark - <第三方分享-配置要分享的参数>
-(void)settingShareParameter
{
    //1.创建分享参数 注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    UIImage *image = [UIImage imageNamed:@"appLogo"];
    NSArray *imageArray = @[image];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"全球首个爆品推荐+智慧社交平台！1亿礼品库、注册必送礼！" images:imageArray url:[NSURL URLWithString:kZHJAppStoreLink] title:@"智惠加" type:SSDKContentTypeAuto];
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //2.分享（可以弹出我们的分享菜单和编辑界面）
        [ShareTool shareWithParams:shareParams];
    }
}

#pragma mark - <记录用户浏览内容>
-(void)userBrowseGoods
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUserBrowseGoods];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"goods_id":self.goods_id};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:nil failBlock:nil];
}

#pragma mark - <获取商品详情数据>
-(void)getGoodsDetailData
{
    if (self.goods_id) {
        MBProgressHUD *hud = [ProgressHUDManager showFullScreenProgressHUDAddTo:self.view animated:YES];
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
                    
                    //判断是否已经收藏
                    if ([model.data.result.is_collected isEqualToString:@"0"]) {
                        self.imgViewCollection.image = [UIImage imageNamed:@"star_black"];
                    }else{
                        self.imgViewCollection.image = [UIImage imageNamed:@"star_yellow"];
                    }
                    
                    for (GoodsDetailImageModel *modelImage in model.data.result.goods_images) {
                        NSString *str = [NSString stringWithFormat:@"%@%@",kDomainImage,modelImage.image_url];
                        [self.bannerArray addObject:str];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self initBuyNowProductMessageView];
                        [self initAddToCartProductMessageView];
                        //传数据给“立即购买选择规格”view(下面三句不能调换)
                        self.productMessageAndBuyNowView.goods_id = self.modelInfo.goods_id;
                        self.productMessageAndBuyNowView.defaultPrice = self.modelInfo.price;
                        self.productMessageAndBuyNowView.goods_code = self.modelInfo.goods_number;
                        self.productMessageAndBuyNowView.dataArray = self.spec_listArray;
                        
                        self.productMessageAddToCartView.goods_id = self.modelInfo.goods_id;
                        self.productMessageAddToCartView.defaultPrice = self.modelInfo.price;
                        self.productMessageAddToCartView.goods_code = self.modelInfo.goods_number;
                        self.productMessageAddToCartView.dataArray = self.spec_listArray;
                        
                        [self.tableView reloadData];
                    });
                }else if ([model.code isEqualToString:@"400"]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                        hudWarning.completionBlock = ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        };
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                    });
                }
            }
        } failBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
            
            if ([model.code isEqualToString:@"200"]) {
                self.imgViewCollection.image = [UIImage imageNamed:@"star_yellow"];
            }
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
        
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
            
            if ([model.code isEqualToString:@"200"]) {
                self.imgViewCollection.image = [UIImage imageNamed:@"star_black"];
            }
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
        
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
-(void)jumpToMoreCommentVCWithGoodsID:(NSString *)goods_id
{
    CommentListViewController *commentListVC = [[CommentListViewController alloc]initWithNibName:NSStringFromClass([CommentListViewController class]) bundle:nil];
    commentListVC.goods_id = goods_id;
    commentListVC.navigationItem.title = @"评论列表";
    [self.navigationController pushViewController:commentListVC animated:YES];
}

#pragma mark - <跳转确认订单页面>
-(void)jumpToOrderConfirmVCWithParameter:(NSDictionary *)dictParameter
{
    OrderConfirmViewController *orderConfirmVC = [[OrderConfirmViewController alloc]initWithNibName:NSStringFromClass([OrderConfirmViewController class]) bundle:nil];
    orderConfirmVC.Parameter = dictParameter;
    orderConfirmVC.JumpID = @"detail";
    orderConfirmVC.hidesBottomBarWhenPushed = YES;
    orderConfirmVC.navigationItem.title = @"确认订单";
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}

#pragma mark - <跳转“我的订单”页面>
-(void)jumpToMyOrderVC
{
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc]init];
    myOrderVC.selectedIndex = 1;
    [self.navigationController pushViewController:myOrderVC animated:NO];
}

#pragma mark - <跳转“聊天界面”>
-(void)jumpToSingleChatVCWithChatter:(NSString *)chatter
{
    ZHJMessageViewController *singleChatVC = [[ZHJMessageViewController alloc]initWithConversationChatter:chatter conversationType:EMConversationTypeChat];
    singleChatVC.delegate = self;
    singleChatVC.dataSource = self;
    singleChatVC.navigationItem.title = @"智惠加客服";
    [self.navigationController pushViewController:singleChatVC animated:YES];
}

#pragma mark - <客服>
- (IBAction)btnSalesCenterAction:(UIButton *)sender
{
    [self jumpToSingleChatVCWithChatter:kZHJService];//客服id为160；
}

#pragma mark - <店铺>
- (IBAction)btnStoreAction:(UIButton *)sender
{
    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"该商品为平台商品,没有商家"];
    [hudWarning hideAnimated:YES afterDelay:1.0];
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
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"popProductMessageView" object:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cloudGlassBGView2];
    [UIView animateWithDuration:0.3 animations:^{
        self.productMessageAddToCartView.frame = CGRectMake(0, kSCREENH_HEIGHT-400, kSCREEN_WIDTH, 400);
    }];
}

#pragma mark - <立即购买>
- (IBAction)btnBuyByNowAction:(UIButton *)sender
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.cloudGlassBGView];
    [UIView animateWithDuration:0.3 animations:^{
        self.productMessageAndBuyNowView.frame = CGRectMake(0, kSCREENH_HEIGHT-400, kSCREEN_WIDTH, 400);
    }];
}

#pragma mark - <初始化立即下单商品规格选择页面>
-(void)initBuyNowProductMessageView
{
    self.cloudGlassBGView = [[UIView alloc]initWithFrame:kScreeFrame];
    self.cloudGlassBGView.backgroundColor = kColorFromRGBAndAlpha(kBlack, 0.4);
    
    self.productMessageAndBuyNowView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BuyNowSelectSpecView class]) owner:nil options:nil].lastObject;
    self.productMessageAndBuyNowView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 400);
    [self.cloudGlassBGView addSubview:self.productMessageAndBuyNowView];
}

#pragma mark - <初始化加入购物车商品规格选择页面>
-(void)initAddToCartProductMessageView
{
    self.cloudGlassBGView2 = [[UIView alloc]initWithFrame:kScreeFrame];
    self.cloudGlassBGView2.backgroundColor = kColorFromRGBAndAlpha(kBlack, 0.4);
    
    self.productMessageAddToCartView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ProductColorAndCountView class]) owner:nil options:nil].lastObject;
    self.productMessageAddToCartView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 400);
    [self.cloudGlassBGView2 addSubview:self.productMessageAddToCartView];
}


#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    //跳转”更多评论“页面
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"JumpToMoreCommentVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSString *goods_id = x.object;
        [self jumpToMoreCommentVCWithGoodsID:goods_id];
    }];
    
    //移除"立即购买"选择规格view
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"removeBuyNowSpecView" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.productMessageAndBuyNowView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 400);
        } completion:^(BOOL finished) {
            [self.cloudGlassBGView removeFromSuperview];
        }];
    }];
    
    //移除"加入购物车"选择规格view
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"removeTheView" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.productMessageAddToCartView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, 400);
        } completion:^(BOOL finished) {
            [self.cloudGlassBGView2 removeFromSuperview];
        }];
    }];
    
    //跳转“确认订单”页面
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"jumpToOrderConfirmVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSDictionary *dictParameter = x.object;
        [self jumpToOrderConfirmVCWithParameter:dictParameter];
    }];
    
    //支付失败后跳转“我的订单”页面
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"failurePayJumpToMyOrderVC" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        NSArray *vcArray = self.navigationController.viewControllers;
        for (UIViewController *vc in vcArray) {
            if ([vc isKindOfClass:[self class]]) {
                [self.navigationController popToViewController:vc animated:NO];
                [self jumpToMyOrderVC];
            }
        }
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



#pragma mark - **** EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource ****
-(id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    if (model.isSender) {
        NSString *headimg = kUserDefaultObject(kUserHeadimg);
        model.avatarURLPath = headimg;
        model.nickname = @"";
    }else{
        model.avatarImage = [UIImage imageNamed:@"appLogo"];
        model.nickname = @"";
    }
    model.failImageName = @"huantu";
    return model;
}



@end
