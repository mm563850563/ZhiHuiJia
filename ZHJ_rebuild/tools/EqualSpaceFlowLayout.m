//
//  EqualSpaceFlowLayout.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "EqualSpaceFlowLayout.h"

@interface EqualSpaceFlowLayout()

@property (nonatomic, strong) NSMutableArray *itemAttributes;

@end

@implementation EqualSpaceFlowLayout

- (id)init
{
    if (self = [super init]) {
//        self.scrollDirection = UICollectionViewScrollDirectionVertical;
//        self.minimumInteritemSpacing = 5;
//        self.minimumLineSpacing = 5;
//        self.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    }
    
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGFloat xOffset = self.sectionInset.left;
    CGFloat yOffset = self.sectionInset.top;
    CGFloat yNextOffset = self.sectionInset.top;
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
        yNextOffset+=(self.minimumLineSpacing + itemSize.height);
        if (yNextOffset > [self collectionView].bounds.size.height - self.sectionInset.bottom) {
            xOffset = self.sectionInset.left;
            yNextOffset = (self.sectionInset.top + self.minimumLineSpacing + itemSize.height);
            yOffset += (itemSize.height + self.minimumLineSpacing);
        }
        else
        {
            yOffset = yNextOffset - (self.minimumLineSpacing + itemSize.height);
        }
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        [_itemAttributes addObject:layoutAttributes];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

@end
