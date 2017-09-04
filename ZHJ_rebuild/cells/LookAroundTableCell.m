//
//  LookAroundTableCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "LookAroundTableCell.h"
#import "PeopleNearbyResultModel.h"

@interface LookAroundTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;

@end

@implementation LookAroundTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect
{
    CGFloat round = self.imgViewPortrait.frame.size.width/2.0;
    self.imgViewPortrait.layer.cornerRadius = round;
    self.imgViewPortrait.layer.masksToBounds = YES;
}

-(void)setModelNearbyResult:(PeopleNearbyResultModel *)modelNearbyResult
{
    _modelNearbyResult = modelNearbyResult;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelNearbyResult.headimg];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:imgURL placeholderImage:kPlaceholder];
    
    self.labelNickName.text = modelNearbyResult.nickname;
    float distance = [modelNearbyResult.distance floatValue];
    self.labelDistance.text = [NSString stringWithFormat:@"%d米",(int)distance];
}

@end
