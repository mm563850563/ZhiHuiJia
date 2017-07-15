//
//  Categate_CategateTableViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "Categate_CategateTableViewCell.h"

//cells
#import "Categate_CategateCollectCell.h"

@interface Categate_CategateTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIView *contentBGView;

@end

@implementation Categate_CategateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        
        CGFloat itemWidth = self.contentView.frame.size.width/3.0;
        CGFloat itemHeight = itemWidth/3.0*4.0;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentBGView.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = kColorFromRGB(kWhite);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([Categate_CategateCollectCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([Categate_CategateCollectCell class])];
    }
    return _collectionView;
}

-(UIView *)contentBGView
{
    if (!_contentBGView) {
        _contentBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.frame.size.width, self.contentView.frame.size.height-20)];
        _contentBGView.backgroundColor = kColorFromRGB(kWhite);
    }
    return _contentBGView;
}

-(void)drawRect:(CGRect)rect
{
    self.contentView.backgroundColor = kColorFromRGB(kWhite);
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.contentView addSubview:self.contentBGView];
    [self.contentBGView addSubview:self.collectionView];
}






#pragma mark - **** UICollectionViewDelegate ,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Categate_CategateCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Categate_CategateCollectCell class]) forIndexPath:indexPath];
    return cell;
}

@end
