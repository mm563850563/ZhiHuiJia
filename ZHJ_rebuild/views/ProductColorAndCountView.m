//
//  ProductColorAndCountView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductColorAndCountView.h"

//cells
#import "ProductStyleSelectionCell.h"

//tools
#import "CALayer+XIBUIColor.h"

@interface ProductColorAndCountView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ProductColorAndCountView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self settingCountBGView];
    [self settingFlowLayout];
    [self settingCollectionView];
}

-(void)settingCountBGView
{
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.countBGView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.countBGView.bounds.size];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.lineWidth = 0.5;
    maskLayer1.strokeColor = [UIColor blackColor].CGColor;
    maskLayer1.fillColor = nil;
    maskLayer1.frame = self.countBGView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    [self.countBGView.layer addSublayer:maskLayer1];
}

-(void)settingFlowLayout
{
    CGFloat itemWidth = self.collectionView.frame.size.width/3.2;
    CGFloat itemHeight = 30;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)settingCollectionView
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([ProductStyleSelectionCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([ProductStyleSelectionCell class])];
}

- (IBAction)btnCancelAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeTheView" object:nil];
}

- (IBAction)btnIncreaseAction:(UIButton *)sender
{
    int count = [self.labelCount.text intValue];
    if (count >= 1) {
        count++;
    }
    self.labelCount.text = [NSString stringWithFormat:@"%d",count];
}


- (IBAction)btnDecreaseAction:(UIButton *)sender
{
    int count = [self.labelCount.text intValue];
    if (count > 1) {
        count--;
    }
    self.labelCount.text = [NSString stringWithFormat:@"%d",count];
}








#pragma mark - **** UICollectionViewDelegate,UICollectionViewDataSource *****
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductStyleSelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ProductStyleSelectionCell class]) forIndexPath:indexPath];
    cell.labelStyleName.text = @"天辣色";
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductStyleSelectionCell *cell = (ProductStyleSelectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.labelStyleName.layer.borderUIColor = kColorFromRGB(kRed);
    cell.labelStyleName.textColor = kColorFromRGB(kRed);
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductStyleSelectionCell *cell = (ProductStyleSelectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.labelStyleName.layer.borderUIColor = kColorFromRGB(kDeepGray);
    cell.labelStyleName.textColor = kColorFromRGB(kDeepGray);
}


@end
