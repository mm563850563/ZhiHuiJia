//
//  PersonalActivityRankCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "PersonalActivityRankCell.h"
#import "PersonalLivenessRank_personal_rank_infoModel.h"

@interface PersonalActivityRankCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelRank;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelLiveness;

@end

@implementation PersonalActivityRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelPersonalRank:(PersonalLivenessRank_personal_rank_infoModel *)modelPersonalRank
{
    _modelPersonalRank = modelPersonalRank;
    
    self.labelRank.text = [NSString stringWithFormat:@"NO.%@",modelPersonalRank.rank];
    self.labelNickName.text = modelPersonalRank.nickname;
    self.labelLiveness.text = [NSString stringWithFormat:@"%@点",modelPersonalRank.total_liveness];
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelPersonalRank.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
}





@end
