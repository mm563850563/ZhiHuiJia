//
//  FailureReviewActivityCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "FailureReviewActivityCell.h"

@interface FailureReviewActivityCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelReviewResult;
@property (weak, nonatomic) IBOutlet UILabel *labelReviewSuggesttion;
@property (weak, nonatomic) IBOutlet UILabel *labelApplyTime;

@end

@implementation FailureReviewActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelRefuseActivityResult:(RefuseActivityResultModel *)modelRefuseActivityResult
{
    _modelRefuseActivityResult = modelRefuseActivityResult;
    self.labelReviewResult.text = [NSString stringWithFormat:@"%@",modelRefuseActivityResult.content];
    self.labelReviewSuggesttion.text = [NSString stringWithFormat:@"%@",modelRefuseActivityResult.opinion];
    //时间
    NSInteger t = [modelRefuseActivityResult.addtime integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *addTime = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *addTimeStr = [formatter stringFromDate:addTime];
    self.labelApplyTime.text = [NSString stringWithFormat:@"申请时间：%@",addTimeStr];
}

@end
