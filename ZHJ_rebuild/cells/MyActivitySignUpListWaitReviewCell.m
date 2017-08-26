//
//  MyActivitySignUpListWaitReviewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyActivitySignUpListWaitReviewCell.h"

@interface MyActivitySignUpListWaitReviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelReason;

@end

@implementation MyActivitySignUpListWaitReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <通过该成员参加活动>
- (IBAction)btnPassAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"passJoinTheActivity" object:self.modelWaitAuditSignUpResult.signup_id];
}

#pragma mark - <拒绝该成员参加活动>
- (IBAction)btnRefuseAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refuseJoinTheActivity" object:self.modelWaitAuditSignUpResult.signup_id];
}


-(void)setModelWaitAuditSignUpResult:(WaitAuditSignUpResultModel *)modelWaitAuditSignUpResult
{
    _modelWaitAuditSignUpResult = modelWaitAuditSignUpResult;
    
    self.labelNickName.text = modelWaitAuditSignUpResult.nickname;
    self.labelReason.text = modelWaitAuditSignUpResult.reason;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelWaitAuditSignUpResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
}




@end
