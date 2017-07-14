//
//  PersonalViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/6.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "PersonalViewController.h"
#import "FeedbackViewController.h"

//cells
#import "PersonalCollectCell.h"

@interface PersonalViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
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
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

#pragma mark - <初始化collectionView>
-(void)initCollectionView
{
    NSArray *arrayTitle = @[@"购物车",@"我的收藏",@"我的余额",@"优惠券",@"客服中心",@"分享邀请",@"关注公众号",@"关于智惠加",@"意见反馈"];
    self.arrayCollection = @[arrayTitle];
    
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
    }else{
        [navigationController setNavigationBarHidden:NO animated:YES];
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
//    cell.labelTitle.text = self.arrayCollection[0][indexPath.row];
    
    return cell;
}



@end
