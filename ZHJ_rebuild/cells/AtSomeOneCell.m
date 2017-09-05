//
//  AtSomeOneCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AtSomeOneCell.h"
#import "GetSimilarUserResultModel.h"

@interface AtSomeOneCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;


@end

@implementation AtSomeOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.btnSelect.selected = YES;
    }else{
        self.btnSelect.selected = NO;
    }
}

-(void)setModelResult:(GetSimilarUserResultModel *)modelResult
{
    _modelResult = modelResult;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelResult.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelNickName.text = modelResult.nickname;
    
}






@end
