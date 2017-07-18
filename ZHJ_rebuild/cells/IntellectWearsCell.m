//
//  IntellectWearsCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "IntellectWearsCell.h"

//tools
//#import "EqualSpaceFlowLayout.h"

//cells
#import "HomeCollectCell1.h"
#import "HomeCollectCell2.h"
#import "HomeCollectCell3.h"

@interface IntellectWearsCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation IntellectWearsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = kColorFromRGB(kWhite);
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        UINib *nibCell1 = [UINib nibWithNibName:NSStringFromClass([HomeCollectCell1 class]) bundle:nil];
        [_collectionView registerNib:nibCell1 forCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell1 class])];
        
        UINib *nibCell2 = [UINib nibWithNibName:NSStringFromClass([HomeCollectCell2 class]) bundle:nil];
        [_collectionView registerNib:nibCell2 forCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell2 class])];
        
        UINib *nibCell3 = [UINib nibWithNibName:NSStringFromClass([HomeCollectCell3 class]) bundle:nil];
        [_collectionView registerNib:nibCell3 forCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell3 class])];
    }
    return _collectionView;
}

-(void)setNumberOfCell:(NSInteger)numberOfCell
{
    _numberOfCell = numberOfCell;
}


-(void)drawRect:(CGRect)rect
{
    [self.contentView addSubview:self.collectionView];
}




#pragma mark - ****** UICollectionViewDelegateFlowLayout *******
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = self.contentView.frame.size.width/2.02;
    CGFloat itemHeight = itemWidth/2.0*3.0;
    
    NSLog(@"%f,%f",itemWidth,itemHeight);
    if (itemHeight > (itemWidth+90)) {
        itemHeight = itemWidth+90;
    }
    CGSize size = CGSizeMake(itemWidth, itemHeight);
//    if (indexPath.item == 1 || indexPath.item == 2) {
//        size = CGSizeMake(itemWidth, itemHeight/2.03);
//    }
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    if (indexPath.item == 0) {
        HomeCollectCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell2 class]) forIndexPath:indexPath];
        cell = cell2;
    }else if (indexPath.item == 1) {
        HomeCollectCell3 *cell3 = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell3 class]) forIndexPath:indexPath];
        cell = cell3;
    }else{
        HomeCollectCell1 *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell1 class]) forIndexPath:indexPath];
        cell = cell1;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
}


@end
