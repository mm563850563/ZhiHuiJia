//
//  YouthColorCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "YouthColorCell.h"

//cells
#import "HomeCollectCell1.h"

//model
#import "HomeGoodsResultModel.h"
#import "UserFavoriteResultModel.h"

@interface YouthColorCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation YouthColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setModel:(HomeGoodsResultModel *)model
{
    if (_model != model) {
        _model = model;
        self.dataArray = model.goods_list;
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
        self.cellHeight = itemHeight*lineCount + (lineCount+1)*5;
    }
}

//-(void)setRecommendGoodsArray:(NSArray *)recommendGoodsArray
//{
//    if (_recommendGoodsArray != recommendGoodsArray) {
//        _recommendGoodsArray = recommendGoodsArray;
//        self.dataArray = recommendGoodsArray;
//        [self.collectionView reloadData];
//        [self.collectionView layoutIfNeeded];
//        
//        CGFloat itemWidth = kSCREEN_WIDTH/2.02;
//        CGFloat itemHeight = itemWidth/2.0*3.0;
//        if (itemHeight > (itemWidth+90)) {
//            itemHeight = itemWidth+90;
//        }
//        
//        NSInteger lineCount = recommendGoodsArray.count/2;
//        if (recommendGoodsArray.count%2 != 0) {
//            lineCount++;
//        }
//        self.cellHeight = itemHeight*lineCount + (lineCount+1)*5;
//    }
//}

-(void)setUserFavoriteArray:(NSArray *)userFavoriteArray
{
//    if (_userFavoriteArray != userFavoriteArray) {
        _userFavoriteArray = userFavoriteArray;
//        self.dataArray = userFavoriteArray;
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        
        CGFloat itemWidth = kSCREEN_WIDTH/2.02;
        CGFloat itemHeight = itemWidth/2.0*3.0;
        if (itemHeight > (itemWidth+90)) {
            itemHeight = itemWidth+90;
        }
        
        NSInteger lineCount = userFavoriteArray.count/2;
        if (userFavoriteArray.count%2 != 0) {
            lineCount++;
        }
        self.cellHeight = itemHeight*lineCount + (lineCount+1)*5;
//    }
}


-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
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
    if (self.userFavoriteArray.count>0) {
        return self.userFavoriteArray.count;
    }else {
        return self.dataArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell1 class]) forIndexPath:indexPath];
    if (self.userFavoriteArray.count>0) {
        UserFavoriteResultModel *model = self.userFavoriteArray[indexPath.item];
        cell.modelUserFavorite = model;
    }else if (self.dataArray.count>0){
        HomeGoodsListModel *model = self.dataArray[indexPath.item];
        cell.model = model;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count>0) {
        HomeGoodsListModel *model = self.dataArray[indexPath.item];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectYouthItem" object:model.goods_id];
    }else if (self.userFavoriteArray.count>0){
        UserFavoriteResultModel *model = self.userFavoriteArray[indexPath.item];
        
        if ([self.fromWhere isEqualToString:@"cart"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"selectYouthItemByCartList" object:model.goods_id];
        }else if([self.fromWhere isEqualToString:@"myCollectionList"]){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"selectYouthItemByCollectionList" object:model.goods_id];
        }
        
    }
    
}



@end
