//
//  MoreProductListViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/17.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MoreProductListViewController.h"

//cells
#import "MoreProductListCell.h"

//views
#import "MoreProduct_SortView.h"

//controllers
#import "ProductDetailViewController.h"

@interface MoreProductListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation MoreProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavigation];
    [self initMoreProduct_SortView];
    [self initCollectionView];
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

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = self.view.frame.size.width/2.02;
        CGFloat itemHeight = itemWidth/2.0*3.1;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        _flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 50);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorFromRGB(kWhite);
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([MoreProductListCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([MoreProductListCell class])];
    }
    return _collectionView;
}


-(void)settingNavigation
{
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - <初始化sortView>
-(void)initMoreProduct_SortView
{
    MoreProduct_SortView *sortView = [[[NSBundle mainBundle] loadNibNamed:@"MoreProduct_SortView" owner:self options:nil] firstObject];
    [self.view addSubview:sortView];
    [sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(50);
    }];
}

-(void)initCollectionView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(50);
    }];
}


#pragma mark - ** UICollectionViewDelegate,UICollectionViewDataSource ***
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoreProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MoreProductListCell class]) forIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc]initWithNibName:NSStringFromClass([ProductDetailViewController class]) bundle:nil];
    [self.navigationController pushViewController:productDetailVC animated:YES];
}



@end
