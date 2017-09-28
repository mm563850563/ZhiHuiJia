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
@property (weak, nonatomic) IBOutlet UIButton *btnApplyAfterSale;

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
    _modelGoods = modelGoods;
    
    self.labelProductName.text = modelGoods.goods_name;
    self.labelSpec.text = modelGoods.spec_key_name;
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",modelGoods.goods_price];
    self.labelCount.text = [NSString stringWithFormat:@"x%@",modelGoods.goods_num];
    
    NSString *market = [NSString stringWithFormat:@"¥%@",modelGoods.market_price];
    NSMutableAttributedString *thoughLineText = [NSMutableAttributedString returnThroughLineWithText:market];
    self.labelMarketPrice.attributedText = thoughLineText;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelGoods.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    //待评价中可以“申请售后”
    if ([self.order_state isEqualToString:@"待评价"]){
        self.btnApplyAfterSale.hidden = NO;
    }else if ([self.order_state isEqualToString:@"待发货"]){
        self.btnApplyAfterSale.hidden = NO;
    }else if ([self.order_state isEqualToString:@"待收货"]){
        self.btnApplyAfterSale.hidden = NO;
    }else if ([self.order_state isEqualToString:@"已完成"]){
        self.btnApplyAfterSale.hidden = NO;
    }else{
        self.btnApplyAfterSale.hidden = YES;
    }
//    if ([self.whereReuseFrom isEqualToString:@"waitToCommentVC"]) {
//        
//    }else if ([self.whereReuseFrom isEqualToString:@"sendedGoodsVC"]) {
//        self.btnApplyAfterSale.hidden = NO;
//    }else if ([self.whereReuseFrom isEqualToString:@"waitToSendoutVC"]) {
//        self.btnApplyAfterSale.hidden = NO;
//    }else{
//        self.btnApplyAfterSale.hidden = YES;
//    }
}


- (IBAction)btnApplyAfterSaleAction:(UIButton *)sender
{
    NSDictionary *dict = @{@"goodsModel":self.modelGoods,
                           @"order_sn":self.order_sn,
                           @"order_id":self.order_id};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"JumpToApplyAfterSaleVC" object:dict];
}










@end
