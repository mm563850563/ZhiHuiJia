//
//  AllCircleMemberListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/29.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AllCircleMemberListCell.h"

@interface AllCircleMemberListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;

@end

@implementation AllCircleMemberListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelCircleMemberResult:(AllCircleMemberResultModel *)modelCircleMemberResult
{
    _modelCircleMemberResult = modelCircleMemberResult;
    self.labelNickName.text = modelCircleMemberResult.nickname;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelCircleMemberResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
}

@end
