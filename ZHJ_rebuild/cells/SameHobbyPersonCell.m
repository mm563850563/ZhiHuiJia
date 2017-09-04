//
//  SameHobbyPersonCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/14.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SameHobbyPersonCell.h"
#import "GetSimilarUserResultModel.h"

@interface SameHobbyPersonCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnOnFocus;

@end

@implementation SameHobbyPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModelSimilarResult:(GetSimilarUserResultModel *)modelSimilarResult
{
    _modelSimilarResult = modelSimilarResult;
    
    self.labelNickName.text = modelSimilarResult.nickname;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelSimilarResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    if ([modelSimilarResult.is_attentioned isEqualToString:@"0"]) {
        self.btnOnFocus.selected = NO;
    }else{
        self.btnOnFocus.selected = YES;
    }
}

@end
