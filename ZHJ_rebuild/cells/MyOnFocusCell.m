//
//  MyOnFocusCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "MyOnFocusCell.h"
#import "TalkLikeResultModel.h"

@interface MyOnFocusCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;

@end

@implementation MyOnFocusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelTalkLikeResult:(TalkLikeResultModel *)modelTalkLikeResult
{
    _modelTalkLikeResult = modelTalkLikeResult;
    
    self.labelNickName.text = modelTalkLikeResult.nickname;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelTalkLikeResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
}












@end
