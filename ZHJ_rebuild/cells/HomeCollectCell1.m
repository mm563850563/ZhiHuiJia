//
//  HomeCollectCell1.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HomeCollectCell1.h"
#import "HomeGoodsListModel.h"
#import "UserFavoriteResultModel.h"
#import "NSMutableAttributedString+ThroughLine.h"

@implementation HomeCollectCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(HomeGoodsListModel *)model
{
    if (_model != model) {
        _model = model;
        
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.img];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:model.market_price font:11];
        self.labelCompare.attributedText = throughLineText;
        
        self.labelProductName.text = model.goods_name;
        self.labelPrice.text = [NSString stringWithFormat:@"¥%@",model.price];
        self.labelProductDetail.text = model.goods_remark;
    }
}

-(void)setModelUserFavorite:(UserFavoriteResultModel *)modelUserFavorite
{
    if (_modelUserFavorite != modelUserFavorite) {
        _modelUserFavorite = modelUserFavorite;
        
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelUserFavorite.img];
        NSURL *url = [NSURL URLWithString:imgStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:modelUserFavorite.market_price font:11];
        self.labelCompare.attributedText = throughLineText;
        
        self.labelProductName.text = modelUserFavorite.goods_name;
        self.labelPrice.text = [NSString stringWithFormat:@"¥%@",modelUserFavorite.price];
        self.labelProductDetail.text = modelUserFavorite.goods_remark;
    }
}

@end
