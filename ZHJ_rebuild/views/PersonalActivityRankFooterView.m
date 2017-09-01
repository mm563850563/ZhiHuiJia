//
//  PersonalActivityRankView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "PersonalActivityRankFooterView.h"

#import "PersonalLivenessRank_my_first_rank_infoModel.h"
@interface PersonalActivityRankFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *labelMyRank;
@property (weak, nonatomic) IBOutlet UILabel *labelMyLiveness;

@end

@implementation PersonalActivityRankFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setModelMyFirstRankInfo:(PersonalLivenessRank_my_first_rank_infoModel *)modelMyFirstRankInfo
{
    _modelMyFirstRankInfo = modelMyFirstRankInfo;
    
    self.labelMyRank.text = [NSString stringWithFormat:@"%@",modelMyFirstRankInfo.rank];
    self.labelMyLiveness.text = [NSString stringWithFormat:@"%@点",modelMyFirstRankInfo.total_liveness];
}


@end
