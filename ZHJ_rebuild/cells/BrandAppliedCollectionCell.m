//
//  BrandAppliedCollectionCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/8.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandAppliedCollectionCell.h"
#import "AllBrandListModel.h"

@implementation BrandAppliedCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(AllBrandListModel *)model
{
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.logo];
    NSURL *url = [NSURL URLWithString:urlstr];
    [self.imgBrand sd_setImageWithURL:url placeholderImage:kPlaceholder];
}

@end
