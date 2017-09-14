//
//  GetGiftViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "GetGiftViewController.h"

//cells
#import "GiftListCell.h"

//tools
#import "ShareTool.h"

//controllers
#import "ShakeAndWinViewController.h"

//models
#import "GetGiftListModel.h"
#import "GetGiftListResultModel.h"
#import "GetGiftList_GiftListModel.h"

//SDKs
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
//#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIEditorViewStyle.h>

@interface GetGiftViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//outlets
@property (weak, nonatomic) IBOutlet UIImageView *imgViewHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIImageView *imgProgress;
//@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
//@property (weak, nonatomic) IBOutlet UILabel *labelFinishSendGift;
//@property (weak, nonatomic) IBOutlet UILabel *labelPayFreight;
//@property (weak, nonatomic) IBOutlet UILabel *labelWaitToSendOut;
//@property (weak, nonatomic) IBOutlet UILabel *labelConfirm;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForImgViewHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;


@property (nonatomic, strong)NSArray *giftListArray;
@property (nonatomic, strong)GetGiftListResultModel *modelResult;

@end

@implementation GetGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getGiftListData];
    [self settingOutlets];
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


#pragma mark - <获取礼物数据>
-(void)getGiftListData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kGetGiftList];
    
    NSString *userID = kUserDefaultObject(kUserInfo);
    NSDictionary *dictParameter = @{@"user_id":userID,
                                    @"type_id":self.type_id};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            GetGiftListModel *model = [[GetGiftListModel alloc]initWithDictionary:dataDict error:nil];
            if ([model.code isEqualToString:@"200"]) {
                self.modelResult = model.data.result;
                self.giftListArray = model.data.result.gift_list;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [hud hideAnimated:YES afterDelay:1.0];
                    [self sendDataToOutlets];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:model.msg];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    [hud hideAnimated:YES afterDelay:1.0];
                });
                
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
                [hud hideAnimated:YES afterDelay:1.0];
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

#pragma mark - <补充outlets数据>
-(void)sendDataToOutlets
{
    NSString *strBanner = [NSString stringWithFormat:@"%@%@",kDomainImage,self.modelResult.banner];
    NSURL *urlBanner = [NSURL URLWithString:strBanner];
    [self.imgViewHeader sd_setImageWithURL:urlBanner placeholderImage:kPlaceholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize size = image.size;
        if (size.width <= 0 || size.height <= 0) {
            size = CGSizeMake(50, 50);
        }
        CGFloat scale = kSCREEN_WIDTH / size.width;
        CGFloat height = scale * size.height;
        self.heightForImgViewHeader.constant = height;
        self.heightForScrollView.constant = 450 + self.heightForImgViewHeader.constant;
    }];
    
//    if ([self.modelResult.status isEqualToString:@"1"]) {
//        self.labelAddress.textColor = kColorFromRGB(kLightBlue);
//    }else if ([self.modelResult.status isEqualToString:@"2"]){
//        self.labelPayFreight.textColor = kColorFromRGB(kLightBlue);
//    }else if ([self.modelResult.status isEqualToString:@"3"]){
//        self.labelWaitToSendOut.textColor = kColorFromRGB(kLightBlue);
//    }else if ([self.modelResult.status isEqualToString:@"4"]){
//        self.labelConfirm.textColor = kColorFromRGB(kLightBlue);
//    }else if ([self.modelResult.status isEqualToString:@"5"]){
//        self.labelFinishSendGift.textColor = kColorFromRGB(kLightBlue);
//    }
}

#pragma mark - <settingOutlets>
-(void)settingOutlets
{
    
    //collection
    self.flowLayout.minimumLineSpacing = 5;
    CGFloat itemWidth = self.collectionView.frame.size.width/4.2;
    CGFloat itemHeight = itemWidth/4.0*5.0;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.delegate =self;
    self.collectionView.dataSource  = self;
    UINib *nibGift = [UINib nibWithNibName:NSStringFromClass([GiftListCell class]) bundle:nil];
    [self.collectionView registerNib:nibGift forCellWithReuseIdentifier:NSStringFromClass([GiftListCell class])];
}

#pragma mark - <第三方分享-配置要分享的参数>
-(void)settingShareParameter
{
    //1.创建分享参数 注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    UIImage *image = [UIImage imageNamed:@"touxiang"];
    NSArray *imageArray = @[image];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"ZHJ" images:imageArray url:[NSURL URLWithString:@"https://www.apple.com"] title:@"智惠加" type:SSDKContentTypeAuto];
        
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        //2.分享（可以弹出我们的分享菜单和编辑界面）
        [ShareTool shareWithParams:shareParams];
    }
}


#pragma mark - <立即分享>
- (IBAction)btnShareAction:(UIButton *)sender
{
    [self settingShareParameter];
}

#pragma mark - <返回按钮响应>
- (IBAction)btnBackAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <摇一摇 拿大礼>
- (IBAction)shakeAndWinAction:(UIButton *)sender
{
    ShakeAndWinViewController *shakeAndWinVC = [[ShakeAndWinViewController alloc]initWithNibName:NSStringFromClass([ShakeAndWinViewController class]) bundle:nil];
    shakeAndWinVC.type_id = self.type_id;
    [self.navigationController pushViewController:shakeAndWinVC animated:YES];
}









#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.giftListArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiftListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GiftListCell class]) forIndexPath:indexPath];
    GetGiftList_GiftListModel *model = self.giftListArray[indexPath.item];
    /****这两句顺序不能乱***/
    cell.winGiftID = self.modelResult.gift_id;
    cell.model = model;
    /****这两句顺序不能乱***/
    return cell;
}




@end
