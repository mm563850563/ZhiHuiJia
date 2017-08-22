//
//  MyTrackTableViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/22.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyTrackTableViewCell.h"

@interface MyTrackTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;

@end

@implementation MyTrackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelMyTrackGoodsInfo:(MyTrackGoodsInfoModel *)modelMyTrackGoodsInfo
{
    _modelMyTrackGoodsInfo = modelMyTrackGoodsInfo;
    
    self.labelProductName.text = modelMyTrackGoodsInfo.goods_name;
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@",modelMyTrackGoodsInfo.goods_price];
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelMyTrackGoodsInfo.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
}

#pragma mark - <分享按钮响应>
- (IBAction)btnShareAction:(UIButton *)sender
{
    
}

@end
