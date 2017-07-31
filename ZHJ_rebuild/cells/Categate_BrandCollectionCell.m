//
//  Categate_BrandCollectionCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "Categate_BrandCollectionCell.h"
#import "AllBrandGoodsListModel.h"

@implementation Categate_BrandCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(AllBrandGoodsListModel *)model
{
    if (_model != model) {
        _model = model;
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.goods_image];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
        self.labelProductName.text = model.goods_name;
        self.labelProductPrice.text = [NSString stringWithFormat:@"¥%@",model.price];
    }
}

@end
