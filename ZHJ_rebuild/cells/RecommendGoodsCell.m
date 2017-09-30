//
//  RecommendGoodsCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "RecommendGoodsCell.h"

//cells
#import "HomeCollectCell1.h"

//models
#import "RecommendGoodsDataModel.h"

@interface RecommendGoodsCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation RecommendGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelRecommendData:(RecommendGoodsDataModel *)modelRecommendData
{
    modelRecommendData = modelRecommendData;
    self.dataArray = modelRecommendData.result;
    [self.collectionView reloadData];
    //        强制刷新界面高度
    [self.collectionView layoutIfNeeded];
    
    CGFloat itemWidth = kSCREEN_WIDTH/2.02;
    CGFloat itemHeight = itemWidth/2.0*3.0;
    if (itemHeight > (itemWidth+90)) {
        itemHeight = itemWidth+90;
    }
    
    NSInteger lineCount = self.dataArray.count/2;
    if (self.dataArray.count%2 != 0) {
        lineCount++;
    }
    self.cellHeight = itemHeight*lineCount + lineCount*4;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 4;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        CGFloat itemWidth = kSCREEN_WIDTH/2.02;
        CGFloat itemHeight = itemWidth/2.0*3.0;
        //        self.height = itemHeight * 8;
        if (itemHeight > (itemWidth+90)) {
            itemHeight = itemWidth+90;
        }
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = kColorFromRGB(kLightGray);
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        UINib *nibCollectCell1 = [UINib nibWithNibName:NSStringFromClass([HomeCollectCell1 class]) bundle:nil];
        [_collectionView registerNib:nibCollectCell1 forCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell1 class])];
    }
    return _collectionView;
}

-(void)drawRect:(CGRect)rect
{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}












#pragma mark - ******* UICollectionViewDelegate,UICollectionViewDataSource *******
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell1 class]) forIndexPath:indexPath];
    RecommendGoodsResultModel *model = self.dataArray[indexPath.item];
    cell.modelRecommendResult = model;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendGoodsResultModel *model = self.dataArray[indexPath.item];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectYouthItem" object:model.goods_id];
    
}









@end
