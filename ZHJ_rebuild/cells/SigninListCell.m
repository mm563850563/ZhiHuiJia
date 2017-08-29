//
//  SigninListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SigninListCell.h"
#import "SigninListResultModel.h"

@interface SigninListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddTime;


@end

@implementation SigninListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelSigninListResult:(SigninListResultModel *)modelSigninListResult
{
    _modelSigninListResult = modelSigninListResult;
    self.labelNickName.text = modelSigninListResult.nickname;
    
    //头像
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelSigninListResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    //时间
    NSInteger t = [modelSigninListResult.addtime integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    self.labelAddTime.text = dateStr;
}

@end
