//
//  FocusPersonHeaderCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/19.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "FocusPersonHeaderCell.h"

@interface FocusPersonHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnFocusCount;
@property (weak, nonatomic) IBOutlet UIButton *btnFansCount;
@property (weak, nonatomic) IBOutlet UIButton *btnOnFocus;

@end

@implementation FocusPersonHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//#pragma mark - <查看关注的人>
//- (IBAction)btnCheckFocusAction:(UIButton *)sender
//{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckFocusAction" object:nil];
//}
//
//#pragma mark - <查看粉丝>
//- (IBAction)btnCheckFansAction:(UIButton *)sender
//{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"CheckFansAction" object:nil
//     ];
//}

#pragma mark - <返回按钮响应>
- (IBAction)btnGoBackAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popFocusPersonHeaderVC" object:nil];
}

#pragma mark - <+关注按钮响应>
- (IBAction)btnOnFocusAction:(UIButton *)sender
{
    if (!sender.selected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"clickOnFocusAttention" object:self.modelFriendResult.user_info.friend_user_id];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"clickOnFocusCancelAttention" object:self.modelFriendResult.user_info.friend_user_id];
    }
    sender.selected = !sender.selected;
}

#pragma mark - <私信按钮响应>
- (IBAction)btnPrivateChatAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickPrivateChat" object:nil];
}

#pragma mark - <个人活跃度排名按钮响应>
- (IBAction)btnPersonActivitySortAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickPersonActivitySort" object:nil];
}

-(void)setModelFriendResult:(FriendHomePageResultModel *)modelFriendResult
{
    _modelFriendResult = modelFriendResult;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelFriendResult.user_info.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelNickName.text = modelFriendResult.user_info.nickname;
    [self.btnFocusCount setTitle:[NSString stringWithFormat:@"%@关注",modelFriendResult.attentions] forState:UIControlStateNormal];
    [self.btnFansCount setTitle:[NSString stringWithFormat:@"%@粉丝",modelFriendResult.fans] forState:UIControlStateNormal];
    
    if ([modelFriendResult.is_attentioned isEqualToString:@"1"]) {
        self.btnOnFocus.selected = YES;
    }else{
        self.btnOnFocus.selected = NO;;
    }
}















@end
