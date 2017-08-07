//
//  BrandDetailHeaderCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandDetailHeaderCell.h"
#import "BrandDetail_BrandDetailModel.h"

@implementation BrandDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.imgProduct mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
    }];
}

-(void)setModel:(BrandDetail_BrandDetailModel *)model
{
    if (_model != model) {
        _model = model;
        
        NSString *imgBannerStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.banner];
        NSURL *urlBanner = [NSURL URLWithString:imgBannerStr];
        [self.imgProduct sd_setImageWithURL:urlBanner placeholderImage:kPlaceholder];
        
        NSString *imgLogoStr  =[NSString stringWithFormat:@"%@%@",kDomainImage,model.logo];
        NSURL *urlLogo = [NSURL URLWithString:imgLogoStr];
        [self.imgBrand sd_setImageWithURL:urlLogo placeholderImage:kPlaceholder];
        
        self.labelStoreName.text = _model.brand_name;
        
    }
}




#pragma mark - <点击在线客服按钮响应>
- (IBAction)btnOnlineContactAction:(UIButton *)sender
{
    
}

@end
