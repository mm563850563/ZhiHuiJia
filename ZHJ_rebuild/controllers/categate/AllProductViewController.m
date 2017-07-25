//
//  AllProductViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AllProductViewController.h"

//views
#import "MoreProduct_SortView.h"

//cells
#import "MoreProductListCell.h"

@interface AllProductViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)MoreProduct_SortView *sortView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation AllProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - <懒加载>
-(MoreProduct_SortView *)sortView
{
    if (!_sortView) {
        _sortView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MoreProduct_SortView class]) owner:nil options:nil].lastObject;
    }
    return _sortView;
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = kSCREEN_WIDTH/2.02;
        CGFloat itemHeight = itemWidth/2.0*3.1;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 50, 50) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorFromRGB(kLightGray);
        _collectionView.scrollEnabled = NO;
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([MoreProductListCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([MoreProductListCell class])];
    }
    return _collectionView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <setUI>
-(void)setUI
{
    [self.view addSubview:self.sortView];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) weakSelf = self;
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(50);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.sortView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
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
    
}



@end
