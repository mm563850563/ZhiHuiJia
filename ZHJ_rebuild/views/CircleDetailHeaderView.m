//
//  CircleDetailHeaderView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/28.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CircleDetailHeaderView.h"

//models
#import "CircleDetailSignin_membersModel.h"
#import "CircleDetailResultModel.h"

@interface CircleDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewCircle;
@property (weak, nonatomic) IBOutlet UILabel *labelSigninCount;
@property (weak, nonatomic) IBOutlet UIView *signinBGView;
@property (weak, nonatomic) IBOutlet UILabel *labelCircleName;
@property (weak, nonatomic) IBOutlet UIButton *btnFocusOrSign;
@property (weak, nonatomic) IBOutlet UILabel *labelMemberCount;
@property (weak, nonatomic) IBOutlet UILabel *labelDynamicCount;

@end

@implementation CircleDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setSigninMembersArray:(NSArray *)signinMembersArray
{
    _signinMembersArray = signinMembersArray;
    
    for (int i=0; i<signinMembersArray.count; i++) {
        
        //动态添加头像
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.signinBGView addSubview:imgView];
        __weak typeof(self) weakSelf = self;
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.labelSigninCount.mas_right).with.offset(10+25*i);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        imgView.layer.cornerRadius = 17.5;
        imgView.layer.masksToBounds = YES;
        
        CircleDetailSignin_membersModel *modelSigninMember = signinMembersArray[i];
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelSigninMember.headimg];
        NSURL *url = [NSURL URLWithString:imgStr];
        [imgView sd_setImageWithURL:url placeholderImage:kPlaceholder];
        
        
        if (i == 7) {
            break;
        }
    }
    
}

-(void)setModelCircleDetailResult:(CircleDetailResultModel *)modelCircleDetailResult
{
    _modelCircleDetailResult = modelCircleDetailResult;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelCircleDetailResult.img];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewCircle sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelCircleName.text = modelCircleDetailResult.circle_name;
    self.labelMemberCount.text = [NSString stringWithFormat:@"%@人",modelCircleDetailResult.members_count];
    self.labelDynamicCount.text = [NSString stringWithFormat:@"%@条动态",modelCircleDetailResult.news];
    self.labelSigninCount.text = [NSString stringWithFormat:@"%@人",modelCircleDetailResult.signin_count];
    
    if ([modelCircleDetailResult.is_attentioned isEqualToString:@"0"]) {
        [self.btnFocusOrSign setTitle:@"关注" forState:UIControlStateNormal];
    }else{
        if ([modelCircleDetailResult.is_signin isEqualToString:@"0"]) {
            [self.btnFocusOrSign setTitle:@"签到" forState:UIControlStateNormal];
        }else{
            [self.btnFocusOrSign setTitle:@"已签到" forState:UIControlStateNormal];
            self.btnFocusOrSign.userInteractionEnabled = NO;
        }
    }
}

- (IBAction)btnFocusOrSignAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"关注"]) {
        //关注圈子
        [[NSNotificationCenter defaultCenter]postNotificationName:@"joinCircleFromCircleDetail" object:self.modelCircleDetailResult.circle_id];
    }else if ([sender.titleLabel.text isEqualToString:@"签到"]){
        //签到
        [[NSNotificationCenter defaultCenter]postNotificationName:@"signinCircleFromCircleDetail" object:self.modelCircleDetailResult.circle_id];
    }
}

- (IBAction)btnCheckSigninListAction:(UIButton *)sender
{
    //查看签到列表
    [[NSNotificationCenter defaultCenter]postNotificationName:@"checkSigninListFromCircleDetail" object:self.modelCircleDetailResult.circle_id];
}


- (IBAction)btnConfigureAction:(UIButton *)sender
{
    //跳转“圈子设置页面”
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToCircleConfigureVC" object:nil];
}




@end
