//
//  HomeCollectCell2.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HomeCollectCell2.h"
#import "NSMutableAttributedString+ThroughLine.h"

#import "HomeGoodsListModel.h"



@interface HomeCollectCell2 ()

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelMarketPrice;

@end

@implementation HomeCollectCell2

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
        
        NSMutableAttributedString *throughLineStr = [NSMutableAttributedString returnThroughLineWithText:model.market_price font:10];
        self.labelMarketPrice.attributedText = throughLineStr;
        
        self.labelProductName.text = model.goods_name;
        self.labelProductRemark.text = model.goods_remark;
        self.labelPrice.text = model.price;
    }
}

@end
