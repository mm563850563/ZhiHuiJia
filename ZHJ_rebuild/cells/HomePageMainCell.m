//
//  HomePageMainCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HomePageMainCell.h"

@implementation HomePageMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setImgString:(NSString *)imgString
{
    if (_imgString != imgString) {
//        _imgString = imgString;
        _imgString = [NSString stringWithFormat:@"%@%@",kDomainImage,imgString];
        NSURL *url = [NSURL URLWithString:_imgString];
        [self.imgProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
    }
}

@end
