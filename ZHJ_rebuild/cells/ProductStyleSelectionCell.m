//
//  ProductStyleSelectionCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/24.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ProductStyleSelectionCell.h"

@implementation ProductStyleSelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected
{
    if (selected) {
        self.btnStyleName.layer.borderColor = kColorFromRGB(kRed).CGColor;
        [self.btnStyleName setTitleColor:kColorFromRGB(kRed) forState:UIControlStateNormal];
    }else{
        self.btnStyleName.layer.borderColor = kColorFromRGB(kDeepGray).CGColor;
        [self.btnStyleName setTitleColor:kColorFromRGB(kDeepGray) forState:UIControlStateNormal];
    }
}

@end
