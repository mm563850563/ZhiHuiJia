//
//  CategoryProductNameCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CategoryProductNameCell.h"

//models
#import "AllClassifyResultModel.h"
#import "AllBrandResultModel.h"

@implementation CategoryProductNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected == YES) {
        self.labelName.textColor = kColorFromRGB(kThemeYellow);
    }else{
        self.labelName.textColor = kColorFromRGB(kBlack);
    }
}

-(void)setModel:(AllClassifyResultModel *)model
{
    if (_model != model) {
        _model = model;
        self.labelName.text = model.name;
    }
}

-(void)setBrandResultModel:(AllBrandResultModel *)brandResultModel
{
    if (_brandResultModel != brandResultModel) {
        _brandResultModel = brandResultModel;
        self.labelName.text = brandResultModel.name;
    }
}

@end
