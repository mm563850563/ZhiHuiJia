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

//models
#import "AllClassifyChidrenFirstModel.h"
#import "AllClassifyChildrenSecondModel.h"

@interface Categate_CategateTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong)UICollectionView *collectionView;
//@property (nonatomic, strong)UIView *contentBGView;
@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation Categate_CategateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(AllClassifyChidrenFirstModel *)model
{
    if (_model != model) {
        _model = model;
        self.dataArray = model.children;
        [self.collectionView reloadData];
        //强制刷新回复界面，然后更新回复区域高度
        [self.collectionView layoutIfNeeded];
//        [self setNeedsLayout];
//        
//        [self layoutIfNeeded];
//        
//        [self.collectionView reloadData];
        
        CGFloat itemWidth = self.contentView.frame.size.width/4.0;
        CGFloat itemHeight = itemWidth/3.0*3.5;

//        __weak typeof(self) weakSelf = self;
//        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(weakSelf.collectionView.collectionViewLayout.collectionViewContentSize.height);
//        }];
        
        NSInteger count  = self.dataArray.count/3;
        if (self.dataArray.count%3 != 0) {
            count++;
        }
        self.cellHeight = count * itemHeight + 30;
    }
}

-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        
        CGFloat itemWidth = self.contentView.frame.size.width/4.0;
        CGFloat itemHeight = itemWidth/3.0*3.5;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
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
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([Categate_CategateCollectCell class]) bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([Categate_CategateCollectCell class])];
    }
    return _collectionView;
}

//-(UIView *)contentBGView
//{
//    if (!_contentBGView) {
//        _contentBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.contentView.frame.size.width, self.contentView.frame.size.height-20)];
//        _contentBGView.backgroundColor = kColorFromRGB(kWhite);
//    }
//    return _contentBGView;
//}

-(void)drawRect:(CGRect)rect
{
    self.contentView.backgroundColor = kColorFromRGB(kWhite);
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//        make.height.mas_equalTo(120);
    }];
}






#pragma mark - **** UICollectionViewDelegate ,UICollectionViewDataSource ****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Categate_CategateCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([Categate_CategateCollectCell class]) forIndexPath:indexPath];
    AllClassifyChildrenSecondModel *model = self.dataArray[indexPath.item];
    cell.model = model;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectCategory_Category_item" object:indexPath];
}

@end
