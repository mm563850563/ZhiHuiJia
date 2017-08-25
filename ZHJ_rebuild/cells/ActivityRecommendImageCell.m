//
//  ActivityRecommendImageCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityRecommendImageCell.h"

@interface ActivityRecommendImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewActivity;

@end

@implementation ActivityRecommendImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setImgStr:(NSString *)imgStr
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainImage,imgStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.imgViewActivity sd_setImageWithURL:url placeholderImage:kPlaceholder];
}

//-(void)setActivityTitle:(NSString *)activityTitle
//{
//    self.labelActivityTitle.text = self.activityTitle;
//}

#pragma mark - <"我要报名"响应>
- (IBAction)btnApplyAction:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applyAction" object:sender];
}


@end
