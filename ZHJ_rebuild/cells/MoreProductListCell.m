//
//  MoreProductListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/17.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MoreProductListCell.h"

#import "RatingBar.h"

@interface MoreProductListCell ()

@property (nonatomic, strong)RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UIView *ratingBarBGView;

@end

@implementation MoreProductListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(RatingBar *)ratingBar
{
    if (!_ratingBar) {
        _ratingBar = [[RatingBar alloc]initWithFrame:self.ratingBarBGView.bounds];
        _ratingBar.starNumber = 3;
        _ratingBar.enable = NO;
    }
    return _ratingBar;
}

-(void)drawRect:(CGRect)rect
{
    [self.ratingBarBGView addSubview:self.ratingBar];
}


@end
