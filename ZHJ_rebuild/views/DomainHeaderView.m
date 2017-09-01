//
//  DomainHeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DomainHeaderView.h"

#import "FriendHomePageResultModel.h"

@interface DomainHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnFocus;
@property (weak, nonatomic) IBOutlet UIButton *btnFans;

@end

@implementation DomainHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (IBAction)btnBackAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backToDiscover" object:nil];
}

- (IBAction)btnMessageAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToMessage" object:nil];
}

- (IBAction)btnEditAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToEdit" object:nil];
}

- (IBAction)btnFocusAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToMyFocus" object:nil];
}

- (IBAction)btnFansAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToMyFans" object:nil];
}

- (IBAction)btnMyActivitiesAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToMyActivities" object:nil];
}

- (IBAction)btnJoinedActivities:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToJoinedActivities" object:nil];
}

- (IBAction)btnRankActivityAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToRankActivity" object:nil];
}

- (IBAction)btnReleaseDynamicAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"DomainToRelease" object:nil];
}


-(void)setModelResult:(FriendHomePageResultModel *)modelResult
{
    _modelResult = modelResult;
    
    self.labelNickName.text = modelResult.user_info.nickname;
    [self.btnFocus setTitle:[NSString stringWithFormat:@"%@关注",modelResult.attentions] forState:UIControlStateNormal];
    [self.btnFans setTitle:[NSString stringWithFormat:@"%@粉丝",modelResult.fans] forState:UIControlStateNormal];
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelResult.user_info.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"appLogo"]];
}


@end
