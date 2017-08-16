//
//  OrderListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/31.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "OrderListCell.h"

#import "NSMutableAttributedString+ThroughLine.h"

@interface OrderListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelSpec;
@property (weak, nonatomic) IBOutlet UILabel *labelMarketPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UILabel *labelRefund;

@end

@implementation OrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModelGoods:(OrderListGoodsModel *)modelGoods
{
    self.labelProductName.text = modelGoods.goods_name;
    self.labelSpec.text = modelGoods.spec_key_name;
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",modelGoods.goods_price];
    self.labelCount.text = [NSString stringWithFormat:@"x%@",modelGoods.goods_num];
    
    NSMutableAttributedString *thoughLineText = [NSMutableAttributedString returnThroughLineWithText:[NSString stringWithFormat:@"%@",modelGoods.market_price] font:11];
    self.labelMarketPrice.attributedText = thoughLineText;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelGoods.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
}









@end
