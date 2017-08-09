//
//  HomeCollectCell3.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/13.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HomeCollectCell3.h"
#import "HomeGoodsListModel.h"
#import "NSMutableAttributedString+ThroughLine.h"

@implementation HomeCollectCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (_dataArray != dataArray) {
        _dataArray = dataArray;
        
        HomeGoodsListModel *model1 = dataArray[0];
        NSString *imgStr1 = [NSString stringWithFormat:@"%@%@",kDomainImage,model1.img];
        NSURL *url1 = [NSURL URLWithString:imgStr1];
        [self.imgProduct1 sd_setImageWithURL:url1 placeholderImage:kPlaceholder];
        
        NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:model1.market_price font:10];
        self.labelMarketPrice1.attributedText = throughLineText;
        
        self.labelProductName1.text = model1.goods_name;
        self.labelProductIntroduce1.text = model1.goods_remark;
        self.labelPrice1.text = model1.price;
        
        if (dataArray.count > 1) {
            HomeGoodsListModel *model2 = dataArray[1];
            NSString *imgStr2 = [NSString stringWithFormat:@"%@%@",kDomainImage,model2.img];
            NSURL *url2 = [NSURL URLWithString:imgStr2];
            [self.imgProduct2 sd_setImageWithURL:url2 placeholderImage:kPlaceholder];
            
            NSMutableAttributedString *throughLineText = [NSMutableAttributedString returnThroughLineWithText:model2.market_price font:10];
            self.labelMarketPrice2.attributedText = throughLineText;
            
            self.labelProductName2.text = model2.goods_name;
            self.labelProductIntroduce2.text = model2.goods_remark;
            self.labelPrice2.text = model2.price;
        }
    }
}

- (IBAction)btnSelectOneAction:(UIButton *)sender
{
    if (self.dataArray.count > 0) {
        HomeGoodsListModel *model = self.dataArray[0];
        NSString *goodsID = model.goods_id;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectItemOneSide" object:goodsID];
    }
}

- (IBAction)btnSelectTwoAction:(UIButton *)sender
{
    if (self.dataArray.count > 1) {
        HomeGoodsListModel *model = self.dataArray[1];
        NSString *goodsID = model.goods_id;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectItemTwoSide" object:goodsID];
    }
}



@end
