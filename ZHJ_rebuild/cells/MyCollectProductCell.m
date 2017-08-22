//
//  MyCollectProductCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyCollectProductCell.h"

@interface MyCollectProductCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductSpec;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@end

@implementation MyCollectProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnDeleteAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeCollectionFromList" object:self.modelMyCollecgtionResult.goods_id];
}

- (IBAction)btnAddToCartAction:(UIButton *)sender
{
    
}




-(void)setModelMyCollecgtionResult:(MyCollectionListResultModel *)modelMyCollecgtionResult
{
    _modelMyCollecgtionResult = modelMyCollecgtionResult;
    self.labelProductName.text = modelMyCollecgtionResult.goods_name;
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",modelMyCollecgtionResult.price];
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelMyCollecgtionResult.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
}

@end
