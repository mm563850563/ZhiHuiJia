//
//  SuccessPayRecommendMemberSingleCountCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/12.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SuccessPayRecommendMemberSingleCountCell.h"

#import "GetInterestingCircleResultModel.h"

@interface SuccessPayRecommendMemberSingleCountCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewCircle;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelMemberCount;
@property (weak, nonatomic) IBOutlet UIButton *btnIsJoined;

@end

@implementation SuccessPayRecommendMemberSingleCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModelInterestCircle:(GetInterestingCircleResultModel *)modelInterestCircle
{
    _modelInterestCircle = modelInterestCircle;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelInterestCircle.logo];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [self.imgViewCircle sd_setImageWithURL:imgURL placeholderImage:kPlaceholder];
    
    self.labelName.text = modelInterestCircle.circle_name;
    self.labelMemberCount.text = [NSString stringWithFormat:@"%@人",modelInterestCircle.members_count];
    
    if ([modelInterestCircle.is_joined isEqualToString:@"1"]) {
        self.btnIsJoined.selected = YES;
    }else{
        self.btnIsJoined.selected = NO;
    }
}

#pragma mark - <加入圈子>
- (IBAction)btnJoinCircleAction:(UIButton *)sender
{
    
}









@end