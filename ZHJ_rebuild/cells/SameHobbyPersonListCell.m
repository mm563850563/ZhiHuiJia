//
//  SameHobbyPersonListCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/7.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SameHobbyPersonListCell.h"

#import "GetSimilarUserResultModel.h"

@interface SameHobbyPersonListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnFocus;

@end

@implementation SameHobbyPersonListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnFocusAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickBtnFocus:user_id:)]) {
        [self.delegate didClickBtnFocus:sender user_id:self.modelResult.user_id];
    }
}

-(void)setModelResult:(GetSimilarUserResultModel *)modelResult
{
    _modelResult = modelResult;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelNickName.text = modelResult.nickname;
    
    if ([modelResult.is_attentioned isEqualToString:@"0"]) {
        self.btnFocus.selected = NO;
    }else{
        self.btnFocus.selected = YES;
    }
}















@end
