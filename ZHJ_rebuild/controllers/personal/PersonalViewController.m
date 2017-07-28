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
#import "FeedbackViewController.h"
#import "GetGiftViewController.h"
#import "CustomerServiceCenterViewController.h"

//cells
#import "PersonalCollectCell.h"


@interface PersonalViewController ()<UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForCollectBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;

@property (weak, nonatomic) IBOutlet UIView *collectionBGView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *arrayCollection;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationController];
    [self initCollectionView];
    
    [self settingHeightForScrollView];
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

#pragma mark - <设置按钮响应>
- (IBAction)btnConfigurationAction:(UIButton *)sender
{
    ConfigurationViewController *configVC = [[ConfigurationViewController alloc]init];
    configVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:configVC animated:YES];
}



#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    self.heightForCollectBGView.constant = kSCREEN_WIDTH;
    CGFloat height1 = self.heightForHeaderView.constant;
    CGFloat height2 = self.heightForCollectBGView.constant;
    self.heightForScrollView.constant = height1 + height2 + 10;
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

















#pragma mark - ****** UINavigationControllerDelegate *******
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"%@",[self class]);
    if ([viewController isKindOfClass:[self class]]) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else if ([viewController isKindOfClass:[GetGiftViewController class]]){
        [navigationController setNavigationBarHidden:YES animated:YES];
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
    if (indexPath.item == 0) {//购物车
        self.tabBarController.selectedIndex = 3;
    }else if (indexPath.item == 1){//我的收藏
        MyCollectProductViewController *myCollectProductVC = [[MyCollectProductViewController alloc]initWithNibName:NSStringFromClass([MyCollectProductViewController class]) bundle:nil];
        myCollectProductVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myCollectProductVC animated:YES];
    }else if (indexPath.item == 2){//我的余额
        MyBalanceViewController *myBalanceVC = [[MyBalanceViewController alloc]initWithNibName:NSStringFromClass([MyBalanceViewController class]) bundle:nil];
        myBalanceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myBalanceVC animated:YES];
    }else if (indexPath.item == 3){//优惠券
        
    }else if (indexPath.item == 4){//客服中心
        CustomerServiceCenterViewController *customerCenterVC = [[CustomerServiceCenterViewController alloc]initWithNibName:NSStringFromClass([CustomerServiceCenterViewController class]) bundle:nil];
        customerCenterVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:customerCenterVC animated:YES];
    }else if (indexPath.item == 5){//分享邀请
        GetGiftViewController *getGiftVC = [[GetGiftViewController alloc]initWithNibName:NSStringFromClass([GetGiftViewController class]) bundle:nil];
        getGiftVC.category = 1;
        getGiftVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:getGiftVC animated:YES];
    }else if (indexPath.item == 6){//关注公众号
        
    }else if (indexPath.item == 7){//关于智惠加
        
    }else if (indexPath.item == 8){//意见反馈
        FeedbackViewController *feedBackVC = [[FeedbackViewController alloc]initWithNibName:NSStringFromClass([FeedbackViewController class]) bundle:nil];
        feedBackVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }
}



@end
