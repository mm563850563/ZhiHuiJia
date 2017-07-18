//
//  SameHobbyCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SameHobbyCell.h"

//cells
#import "SameHobbyPersonCell.h"

@interface SameHobbyCell ()<UICollectionViewDelegate ,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

@end

@implementation SameHobbyCell

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
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        
        CGFloat itemWidth = self.contentView.frame.size.width/4.0;
        CGFloat itemHeight = itemWidth/5.0*6.0;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = kColorFromRGB(kWhite);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([SameHobbyPersonCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([SameHobbyPersonCell class])];
    }
    return _collectionView;
}

-(void)drawRect:(CGRect)rect
{
    [self.contentView addSubview:self.collectionView];
}






#pragma mark - **** UICollectionViewDelegate ,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SameHobbyPersonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SameHobbyPersonCell class]) forIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"SameHobbyCell" object:nil];
}


@end
