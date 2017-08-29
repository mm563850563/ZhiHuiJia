//
//  ActivityRankNormalCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityRankNormalCell.h"

@interface ActivityRankNormalCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelRank;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCircle;
@property (weak, nonatomic) IBOutlet UILabel *labelCircleName;
@property (weak, nonatomic) IBOutlet UILabel *labelLiveness;
@property (weak, nonatomic) IBOutlet UIButton *btnOnFocus;

@end

@implementation ActivityRankNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnOnFocusAction:(UIButton *)sender
{
    
}

-(void)setModelRankInfo:(RankList_circle_rank_infoModel *)modelRankInfo
{
    _modelRankInfo = modelRankInfo;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelRankInfo.logo];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewCircle sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelRank.text = [NSString stringWithFormat:@"No.%@",modelRankInfo.rank];
    self.labelCircleName.text = modelRankInfo.circle_name;
    self.labelLiveness.text = [NSString stringWithFormat:@"%@点",modelRankInfo.total_liveness];
    
    if ([modelRankInfo.is_attentioned isEqualToString:@"1"]) {
        self.btnOnFocus.selected = YES;
    }else{
        self.btnOnFocus.selected = NO;
    }
}


@end
