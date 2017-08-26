//
//  MyActivitySignUpListPassedCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyActivitySignUpListPassedCell.h"

@interface MyActivitySignUpListPassedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelReason;
@property (weak, nonatomic) IBOutlet UIButton *btnOnFocus;

@end

@implementation MyActivitySignUpListPassedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - <关注该成员>
- (IBAction)btnOnFocusAction:(UIButton *)sender
{
    if (!sender.selected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"attentionFriend" object:self.modelWaitAuditSignUpResult.friend_user_id];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelAttention" object:self.modelWaitAuditSignUpResult.friend_user_id];
    }
}

-(void)setModelWaitAuditSignUpResult:(WaitAuditSignUpResultModel *)modelWaitAuditSignUpResult
{
    _modelWaitAuditSignUpResult = modelWaitAuditSignUpResult;
    
    self.labelNickName.text = modelWaitAuditSignUpResult.nickname;
    self.labelReason.text = modelWaitAuditSignUpResult.reason;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelWaitAuditSignUpResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    if ([modelWaitAuditSignUpResult.is_attentioned isEqualToString:@"1"]) {
        self.btnOnFocus.selected = YES;
    }else if ([modelWaitAuditSignUpResult.is_attentioned isEqualToString:@"0"]){
        self.btnOnFocus.selected = NO;
    }
}


@end
