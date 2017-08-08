//
//  Categate_Brand_HeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "Categate_Brand_HeaderView.h"
#import "AllBrandListModel.h"
#import "BrandAppliedCollectionCell.h"

@interface Categate_Brand_HeaderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)NSString *brand_id;
@property (weak, nonatomic) IBOutlet UIView *collectionBGView;
@property (nonatomic, assign)CGFloat width;

@end

@implementation Categate_Brand_HeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self settingCollectionView];
    [self imgHeaderAddInteraction];
}

-(void)drawRect:(CGRect)rect
{
    self.width = self.collectionBGView.frame.size.width;
    [self settingCollectionView];
}

-(void)settingCollectionView
{
    CGFloat itemWidth = (self.width)/3.0;
    CGFloat itemHeight = 40;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([BrandAppliedCollectionCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([BrandAppliedCollectionCell class])];
    
}

-(void)imgHeaderAddInteraction
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postNotificationWithRAC)];
    [self.imgHeader addGestureRecognizer:tap];
}
-(void)postNotificationWithRAC
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickImgBrandApply" object:self.model.goods_id];
}


-(void)setModel:(AllBrandContentModel *)model
{
    _model = model;
    
    NSString *urlStrHeader = [NSString stringWithFormat:@"%@%@",kDomainImage,model.banner];
    NSURL *urlHeader = [NSURL URLWithString:urlStrHeader];
    [self.imgHeader sd_setImageWithURL:urlHeader placeholderImage:kPlaceholder];
    
    [self.collectionView reloadData];
}







#pragma mark - *** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.brand_list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandAppliedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BrandAppliedCollectionCell class]) forIndexPath:indexPath];
    AllBrandListModel *modelBrandList = self.model.brand_list[indexPath.item];
    cell.model = modelBrandList;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllBrandListModel *modelBrandList = self.model.brand_list[indexPath.item];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickBtnBrand" object:modelBrandList];
}


@end
