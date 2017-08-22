//
//  JoinedCircleCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "JoinedCircleCell.h"
#import "MyJoinedCircleResultModel.h"
@interface JoinedCircleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelCircleName;
@property (weak, nonatomic) IBOutlet UILabel *labelCircleMemberCount;

@end

@implementation JoinedCircleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModelJoinedCircle:(MyJoinedCircleResultModel *)modelJoinedCircle
{
    _modelJoinedCircle = modelJoinedCircle;
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelJoinedCircle.logo];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelCircleName.text = modelJoinedCircle.circle_name;
    self.labelCircleMemberCount.text = [NSString stringWithFormat:@"%@个成员",modelJoinedCircle.members_count];
}


@end
