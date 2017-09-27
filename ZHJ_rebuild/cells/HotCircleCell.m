//
//  HotCircleCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HotCircleCell.h"

@interface HotCircleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPotrait;
@property (weak, nonatomic) IBOutlet UILabel *labelCircleName;
@property (weak, nonatomic) IBOutlet UILabel *labelMemberCount;

@end

@implementation HotCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelCircleInfo:(GetHotCycleCircleInfoModel *)modelCircleInfo
{
    _modelCircleInfo = modelCircleInfo;
    self.labelCircleName.text = modelCircleInfo.circle_name;
    self.labelMemberCount.text = [NSString stringWithFormat:@"%@成员",modelCircleInfo.members_count];
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelCircleInfo.logo];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgPotrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
}

-(void)setModelJoinedCircle:(MyJoinedCircleResultModel *)modelJoinedCircle
{
    _modelJoinedCircle = modelJoinedCircle;
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelJoinedCircle.logo];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgPotrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelCircleName.text = modelJoinedCircle.circle_name;
    self.labelMemberCount.text = [NSString stringWithFormat:@"%@个成员",modelJoinedCircle.members_count];
}

-(void)setModelSearchCircle:(SearchCircleResultModel *)modelSearchCircle
{
    _modelSearchCircle = modelSearchCircle;
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelSearchCircle.logo];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgPotrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelCircleName.text = modelSearchCircle.circle_name;
    self.labelMemberCount.text = [NSString stringWithFormat:@"%@个成员",modelSearchCircle.members_count];
}




@end
