//
//  SuccessPayRecommendMemberCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/15.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SuccessPayRecommendMemberCell.h"

#import "GetInterestingCircleResultModel.h"

//tools
#import "UIImageView+Rotation.h"

@interface SuccessPayRecommendMemberCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewCircle;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelMemberCount;
@property (weak, nonatomic) IBOutlet UIButton *btnIsJoined;
@property (weak, nonatomic) IBOutlet UIImageView *imgJoined;

@end

@implementation SuccessPayRecommendMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self settingOutlets];
}

#pragma mark - <配置outlets>
-(void)settingOutlets
{
//    [self.imgViewCircle startRotating];
}

-(void)setModelInterestCircle:(GetInterestingCircleResultModel *)modelInterestCircle
{
    
    _modelInterestCircle = modelInterestCircle;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelInterestCircle.logo];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [self.imgViewCircle sd_setImageWithURL:imgURL placeholderImage:kPlaceholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imgViewCircle startRotating];
        });
    }];
    
    self.labelName.text = modelInterestCircle.circle_name;
    self.labelMemberCount.text = [NSString stringWithFormat:@"%@人",modelInterestCircle.members_count];
    
    if ([modelInterestCircle.is_joined isEqualToString:@"1"]) {
        self.btnIsJoined.selected = YES;
        self.imgJoined.hidden = NO;
    }else{
        self.btnIsJoined.selected = NO;
        self.imgJoined.hidden = YES;
    }
}

-(void)setRotationOrder:(NSString *)rotationOrder
{
//    if ([rotationOrder isEqualToString:@"resume"]) {
//        [self.imgViewCircle resumeRotate];
//    }else if ([rotationOrder isEqualToString:@"pause"]){
//        [self.imgViewCircle stopRotating];
//    }
}

#pragma mark - <加入圈子>
- (IBAction)btnJoinCircleAction:(UIButton *)sender
{
    
}

@end
