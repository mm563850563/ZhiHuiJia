//
//  ActivityRecommendApplyCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityRecommendApplyCell.h"

@interface ActivityRecommendApplyCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelReason;
@property (weak, nonatomic) IBOutlet UIButton *btnFocus;

@end

@interface ActivityRecommendApplyCell ()


@end

@implementation ActivityRecommendApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelSignUpList:(ActivitySignUpListResultModel *)modelSignUpList
{
    _modelSignUpList = modelSignUpList;
    
    self.labelNickName.text = modelSignUpList.nickname;
    self.labelReason.text = modelSignUpList.reason;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelSignUpList.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    if ([modelSignUpList.is_attentioned isEqualToString:@"0"]) {
        self.btnFocus.selected = NO;
    }else{
        self.btnFocus.selected = YES;
    }
}

@end
