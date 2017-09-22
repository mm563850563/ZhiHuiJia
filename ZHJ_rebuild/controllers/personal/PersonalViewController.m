//
//  PersonalViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/6.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "PersonalViewController.h"

//controllers
#import "ConfigurationViewController.h"
#import "FeedbackViewController.h"
#import "MyCollectProductViewController.h"
#import "MyBalanceViewController.h"
#import "GetGiftViewController.h"
#import "CustomerServiceCenterViewController.h"
#import "MyOrderViewController.h"
#import "MyDiscountCouponViewController.h"
#import "AfterSalesViewController.h"
#import "WeChatAccountViewController.h"
#import "AboutUsViewController.h"
#import "MyTrackViewController.h"
#import "ModifyPasswordViewController.h"
#import "NotificationViewController.h"
//***************test********
#import "SuccessPayViewController.h"

//cells
#import "PersonalCollectCell.h"
#import "ShareTool.h"

//tools
#import "UIButton+Badge.h"

//SDKs
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>


@interface PersonalViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForCollectBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;

@property (weak, nonatomic) IBOutlet UIView *collectionBGView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *arrayCollection;


@property (weak, nonatomic) IBOutlet UIButton *btnWaitToPay;
@property (weak, nonatomic) IBOutlet UIButton *btnWaitToShipping;
@property (weak, nonatomic) IBOutlet UIButton *btnWaitToReceive;
@property (weak, nonatomic) IBOutlet UIButton *btnWaitToComment;
@property (weak, nonatomic) IBOutlet UIButton *btnAfterSale;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnPotrait;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPersonalCenterData];
    [self setNavigationController];
    [self initCollectionView];
    
    [self settingHeightForScrollView];
    
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

#pragma mark - <获取个人中心数据>
-(void)getPersonalCenterData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kPersonalCenter];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo)};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                NSDictionary *result = dataDict[@"data"][@"result"];
                NSDictionary *user_info = result[@"user_info"];
                [self fillDataWithResult:result userInfo:user_info];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <填充数据>
-(void)fillDataWithResult:(NSDictionary *)result userInfo:(NSDictionary *)user_info
{
    if (![result[@"pay_count"] isEqual:@0]) {
        self.btnWaitToPay.badgeValue = [NSString stringWithFormat:@"%@",result[@"pay_count"]];
        self.btnWaitToPay.badgeOriginY = 0;
        self.btnWaitToPay.badgeOriginX = 35;
    }
    
    if (![result[@"deliver_count"] isEqual:@0]) {
        self.btnWaitToShipping.badgeValue = [NSString stringWithFormat:@"%@",result[@"deliver_count"]];
        self.btnWaitToShipping.badgeOriginY = 0;
        self.btnWaitToShipping.badgeOriginX = 35;
    }
    
    if (![result[@"receive_count"] isEqual:@0]) {
        self.btnWaitToReceive.badgeValue = [NSString stringWithFormat:@"%@",result[@"receive_count"]];
        self.btnWaitToReceive.badgeOriginY = 0;
        self.btnWaitToReceive.badgeOriginX = 35;
    }
    
    if (![result[@"comment_count"] isEqual:@0]) {
        self.btnWaitToComment.badgeValue = [NSString stringWithFormat:@"%@",result[@"comment_count"]];
        self.btnWaitToComment.badgeOriginY = 0;
        self.btnWaitToComment.badgeOriginX = 35;
    }
    
    
    self.labelUserName.text = user_info[@"nickname"];
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,user_info[@"cdn_headimg"]];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    
}

#pragma mark - <配置navigationBar>
-(void)setNavigationController
{
    self.navigationController.delegate = self;
}

#pragma mark - <初始化collectionView>
-(void)initCollectionView
{
    NSArray *arrayTitle = @[@"我的钱包",@"优惠券",@"我的收藏",@"分享邀请",@"客服中心",@"足迹",@"关注公众号",@"关于我们",@"意见反馈"];
    NSArray *arrayPhoto = @[@"my_ wallet",@"discount",@"my_collection",@"share_invite",@"customer_center",@"footprint",@"focus_public",@"about_us",@"feedback"];
    self.arrayCollection = @[arrayTitle,arrayPhoto];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    CGFloat itemWidth = kSCREEN_WIDTH/3.02;
    CGFloat itemHeight = itemWidth;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.collectionView  = [[UICollectionView alloc]initWithFrame:self.collectionBGView.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = kColorFromRGB(kLightGray);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionBGView addSubview:self.collectionView];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PersonalCollectCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([PersonalCollectCell class])];
}

#pragma mark - <跳转“我的钱包”页面>
-(void)jumpToMyBalanceVC
{
    MyBalanceViewController *myBalanceVC = [[MyBalanceViewController alloc]initWithNibName:NSStringFromClass([MyBalanceViewController class]) bundle:nil];
    myBalanceVC.hidesBottomBarWhenPushed = YES;
    myBalanceVC.navigationItem.title = @"我的钱包";
    [self.navigationController pushViewController:myBalanceVC animated:YES];
}

#pragma mark - <跳转“我的订单”页面>
-(void)jumpToMyOrderVCWithSelectedIndex:(NSInteger)selectedIndex
{
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc]init];
    myOrderVC.selectedIndex = selectedIndex;
    myOrderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

#pragma mark - <跳转”优惠券“页面>
-(void)jumpToDiscountCouponVC
{
    MyDiscountCouponViewController *myCouponVC = [[MyDiscountCouponViewController alloc]initWithNibName:NSStringFromClass([MyDiscountCouponViewController class]) bundle:nil];
    myCouponVC.hidesBottomBarWhenPushed = YES;
    myCouponVC.navigationItem.title = @"优惠券";
    [self.navigationController pushViewController:myCouponVC animated:YES];
}

#pragma mark - <跳转“客服中心”页面>
-(void)jumpToCustomerCenterVC
{
    CustomerServiceCenterViewController *customerCenterVC = [[CustomerServiceCenterViewController alloc]initWithNibName:NSStringFromClass([CustomerServiceCenterViewController class]) bundle:nil];
    customerCenterVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:customerCenterVC animated:YES];
}

#pragma mark - <跳转“我的收藏”页面>
-(void)jumpToMyCollectionVC
{
    MyCollectProductViewController *myCollectProductVC = [[MyCollectProductViewController alloc]initWithNibName:NSStringFromClass([MyCollectProductViewController class]) bundle:nil];
    myCollectProductVC.hidesBottomBarWhenPushed = YES;
    myCollectProductVC.navigationItem.title = @"我的收藏";
    [self.navigationController pushViewController:myCollectProductVC animated:YES];
}

#pragma mark - <跳转“售后”页面>
-(void)jumpToAfterSalesVC
{
    AfterSalesViewController *afterSalesVC = [[AfterSalesViewController alloc]initWithNibName:NSStringFromClass([AfterSalesViewController class]) bundle:nil];
    afterSalesVC.hidesBottomBarWhenPushed = YES;
    afterSalesVC.navigationItem.title = @"退款/维修";
    [self.navigationController pushViewController:afterSalesVC animated:YES];
}

#pragma mark - <跳转“微信公众号”页面>
-(void)jumpToWeChatAccountVC
{
    WeChatAccountViewController *weChatAccountVC = [[WeChatAccountViewController alloc]initWithNibName:NSStringFromClass([WeChatAccountViewController class]) bundle:nil];
    weChatAccountVC.hidesBottomBarWhenPushed = YES;
    weChatAccountVC.navigationItem.title = @"微信公众号";
    [self.navigationController pushViewController:weChatAccountVC animated:YES];
}

#pragma mark - <跳转“关于我们”页面>
-(void)jumpToAboutUsVC
{
    AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc]initWithNibName:NSStringFromClass([AboutUsViewController class]) bundle:nil];
    aboutUsVC.hidesBottomBarWhenPushed = YES;
    aboutUsVC.navigationItem.title = @"关于我们";
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}

#pragma mark - <跳转“我的足迹”页面>
-(void)jumpToMyTrackVC
{
    MyTrackViewController *myTrackVC = [[MyTrackViewController alloc]initWithNibName:NSStringFromClass([MyTrackViewController class]) bundle:nil];
    myTrackVC.hidesBottomBarWhenPushed = YES;
    myTrackVC.navigationItem.title = @"我的足迹";
    [self.navigationController pushViewController:myTrackVC animated:YES];
}

#pragma mark - <跳转”意见反馈“页面>
-(void)jumpToFeedbackVC
{
    FeedbackViewController *feedBackVC = [[FeedbackViewController alloc]initWithNibName:NSStringFromClass([FeedbackViewController class]) bundle:nil];
    feedBackVC.hidesBottomBarWhenPushed = YES;
    feedBackVC.navigationItem.title = @"意见反馈";
    [self.navigationController pushViewController:feedBackVC animated:YES];
}

#pragma mark - <设置按钮响应>
- (IBAction)btnConfigurationAction:(UIButton *)sender
{
    ConfigurationViewController *configVC = [[ConfigurationViewController alloc]init];
    configVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:configVC animated:YES];
}

#pragma mark - <跳转“消息”页面>
- (IBAction)btnMessageAction:(UIButton *)sender
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc]init];
    [self.navigationController pushViewController:notificationVC animated:YES];
    
}


#pragma mark - <设置“我的订单”响应>
- (IBAction)btnMyOrderAction:(UIButton *)sender
{
    [self jumpToMyOrderVCWithSelectedIndex:1];
}

#pragma mark - <设置“待付款”响应>
- (IBAction)btnWaitToPayAction:(UIButton *)sender
{
    [self jumpToMyOrderVCWithSelectedIndex:2];
}

#pragma mark - <设置“待发货”响应>
- (IBAction)btnWaitToSendOutAction:(UIButton *)sender
{
    [self jumpToMyOrderVCWithSelectedIndex:3];
}

#pragma mark - <设置“已发货”响应>
- (IBAction)btnsendedGoodsAction:(UIButton *)sender
{
    [self jumpToMyOrderVCWithSelectedIndex:4];
}

#pragma mark - <设置“待评价”响应>
- (IBAction)btnWaitToCommentAction:(UIButton *)sender
{
    [self jumpToMyOrderVCWithSelectedIndex:5];
}

#pragma mark - <设置“退换／售后”响应>
- (IBAction)btnAfterSalesAction:(UIButton *)sender
{
    [self jumpToAfterSalesVC];
}



#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    self.heightForCollectBGView.constant = kSCREEN_WIDTH;
    CGFloat height1 = self.heightForHeaderView.constant;
    CGFloat height2 = self.heightForCollectBGView.constant;
    self.heightForScrollView.constant = height1 + height2 + 60;
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - <第三方分享-配置要分享的参数>
-(void)settingShareParameter
{
    //1.创建分享参数 注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    UIImage *image = [UIImage imageNamed:@"appLogo"];
    NSArray *imageArray = @[image];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"1亿礼品库,注册必送礼！" images:imageArray url:[NSURL URLWithString:kZHJAppStoreLink] title:@"智惠加" type:SSDKContentTypeAuto];
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //2.分享（可以弹出我们的分享菜单和编辑界面）
        [ShareTool shareWithParams:shareParams];
    }
}

#pragma mark - <rac响应>
-(void)respondWithRAC
{
    
}















#pragma mark - ****** UINavigationControllerDelegate *******
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"%@",[self class]);
    if ([viewController isKindOfClass:[self class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
        [navigationController.navigationBar setTranslucent:NO];
    }else if ([viewController isKindOfClass:[GetGiftViewController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else if ([viewController isKindOfClass:[MyOrderViewController class]]){
        [navigationController setNavigationBarHidden:NO animated:YES];
        [navigationController.navigationBar setTranslucent:NO];
    }else if ([viewController isKindOfClass:[AfterSalesViewController class]]){
        [navigationController setNavigationBarHidden:NO animated:YES];
        [navigationController.navigationBar setTranslucent:NO];
    }else if ([viewController isKindOfClass:[ModifyPasswordViewController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
        [navigationController.navigationBar setTranslucent:NO];
    }else if ([viewController isKindOfClass:[NotificationViewController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
        [navigationController.navigationBar setTranslucent:NO];
    }else if ([viewController isKindOfClass:[SuccessPayViewController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
        [navigationController.navigationBar setTranslucent:NO];
    }else{
        [navigationController setNavigationBarHidden:NO animated:YES];
        [navigationController.navigationBar setTranslucent:NO];
    }
}


#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PersonalCollectCell class]) forIndexPath:indexPath];
    cell.labelTitle.text = self.arrayCollection[0][indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:self.arrayCollection[1][indexPath.row]]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {//我的钱包
        [self jumpToMyBalanceVC];
    }else if (indexPath.item == 1){//优惠券
        [self jumpToDiscountCouponVC];
    }else if (indexPath.item == 2){//我的收藏
        [self jumpToMyCollectionVC];
    }else if (indexPath.item == 3){//分享邀请
        [self settingShareParameter];
    }else if (indexPath.item == 4){//客服中心
        [self jumpToCustomerCenterVC];
    }else if (indexPath.item == 5){//足迹
        [self jumpToMyTrackVC];
    }else if (indexPath.item == 6){//关注公众号
        [self jumpToWeChatAccountVC];
    }else if (indexPath.item == 7){//关于我们
        [self jumpToAboutUsVC];
    }else if (indexPath.item == 8){//意见反馈
        [self jumpToFeedbackVC];
    }
}



@end
