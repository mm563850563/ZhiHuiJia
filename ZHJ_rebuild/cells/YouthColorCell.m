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
#import "YouthColorModel.h"

@interface YouthColorCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation YouthColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




//-(void)setNumberOfCell:(NSInteger)numberOfCell
//{
//    self.numberOfCell = numberOfCell;
//}


-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        CGFloat itemWidth = self.contentView.frame.size.width/2.02;
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
//        [self.contentView addSubview:_collectionView];
//        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//        }];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        UINib *nibCollectCell1 = [UINib nibWithNibName:NSStringFromClass([HomeCollectCell1 class]) bundle:nil];
        [_collectionView registerNib:nibCollectCell1 forCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell1 class])];
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



#pragma mark - ******* UICollectionViewDelegate,UICollectionViewDataSource *******
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HomeCollectCell1 class]) forIndexPath:indexPath];
    return cell;
}



@end
