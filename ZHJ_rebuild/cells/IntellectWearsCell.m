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

#import "HomeGoodsResultModel.h"

@interface IntellectWearsCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataArray;

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
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 5, 0);
        _flowLayout.minimumLineSpacing = 2;
        _flowLayout.minimumInteritemSpacing = 0;
        CGFloat itemWidth = kSCREEN_WIDTH/2.01;
        CGFloat itemHeight = itemWidth/2.0*3.0;
        
//        NSLog(@"%f,%f",itemWidth,itemHeight);
        if (itemHeight > (itemWidth+90)) {
            itemHeight = itemWidth+90;
        }
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    }
    return _flowLayout;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = kColorFromRGB(kLightGray);
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




-(void)drawRect:(CGRect)rect
{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)setModel:(HomeGoodsResultModel *)model
{
    if (_model != model) {
        _model = model;
        self.dataArray = model.goods_list;
        [self.collectionView reloadData];
//        强制刷新界面高度
        [self.collectionView layoutIfNeeded];
        
        CGFloat itemWidth = kSCREEN_WIDTH/2.01;
        CGFloat itemHeight = itemWidth/2.0*3.0;
        if (itemHeight > (itemWidth+90)) {
            itemHeight = itemWidth+90;
        }
        
        NSInteger lineCount = (self.dataArray.count-1)/2;
        if ((self.dataArray.count-1)%2 != 0) {
            lineCount++;
        }
        self.cellHeight = itemHeight*lineCount + 5;
    }
}












#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count-1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    if (indexPath.item == 0) {
        HomeCollectCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell2 class]) forIndexPath:indexPath];
        HomeGoodsListModel *model = self.dataArray[indexPath.item];
        cell2.model = model;
        cell = cell2;
    }else if (indexPath.item == 1) {
        HomeCollectCell3 *cell3 = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell3 class]) forIndexPath:indexPath];
        NSMutableArray *dataArray = [NSMutableArray array];
        HomeGoodsListModel *model1 = self.dataArray[indexPath.item];
        [dataArray addObject:model1];
        if (self.dataArray.count > 2) {
            HomeGoodsListModel *model2 = self.dataArray[indexPath.item+1];
            [dataArray addObject:model2];
        }
        cell3.dataArray = dataArray;
        cell = cell3;
    }else{
        HomeGoodsListModel *model = [[HomeGoodsListModel alloc]init];
        if (self.dataArray.count > 3 && indexPath.row < self.dataArray.count-1) {
            model = self.dataArray[indexPath.item+1];
        }
        HomeCollectCell1 *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell1 class]) forIndexPath:indexPath];
        cell1.model = model;
        cell = cell1;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 1) {
        NSMutableArray *dataArray = [NSMutableArray array];
        HomeGoodsListModel *model1 = self.dataArray[indexPath.item];
        [dataArray addObject:model1];
        if (self.dataArray.count > 2) {
            HomeGoodsListModel *model2 = self.dataArray[indexPath.item+1];
            [dataArray addObject:model2];
        }
    }else if (indexPath.row > 1){
        HomeGoodsListModel *model = [[HomeGoodsListModel alloc]init];
        if (self.dataArray.count > 3 && indexPath.row < self.dataArray.count-1) {
            model = self.dataArray[indexPath.item+1];
        }
        NSString *goodsID = model.goods_id;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectIntellectWearOverTwoItem" object:goodsID];
    }else{
        HomeGoodsListModel *model = self.dataArray[indexPath.item];
        NSString *goodsID = model.goods_id;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectIntellectWearNormalItem" object:goodsID];
    }
}


@end
