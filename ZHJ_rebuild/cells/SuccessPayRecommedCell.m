//
//  SuccessPayRecommedCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SuccessPayRecommedCell.h"

//cells
#import "SuccessPayRecommendMemberCell.h"

@interface SuccessPayRecommedCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation SuccessPayRecommedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = kColorFromRGB(kLightGray);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect
{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        CGFloat itemWidth = (kSCREEN_WIDTH-20)/2.0;
        CGFloat itemHeight = itemWidth/3.0*2;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorFromRGB(kLightGray);
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([SuccessPayRecommendMemberCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([SuccessPayRecommendMemberCell class])];
    }
    return _collectionView;
}













#pragma mark - **** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SuccessPayRecommendMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SuccessPayRecommendMemberCell class]) forIndexPath:indexPath];
    return cell;
}







@end
