//
//  Categate_CategateCollectCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "Categate_CategateCollectCell.h"

//models
#import "AllClassifyChildrenSecondModel.h"

@implementation Categate_CategateCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

-(void)setModel:(AllClassifyChildrenSecondModel *)model
{
    if (_model != model) {
        _model = model;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainImage,model.image];
        NSURL *url = [NSURL URLWithString:urlStr];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        self.labelProductName.text = model.name;
    }
}




@end
