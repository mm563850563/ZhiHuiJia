//
//  CommentAndAboutMeCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CommentAndAboutMeCell.h"
#import "MessageResultModel.h"

@interface CommentAndAboutMeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end

@implementation CommentAndAboutMeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModelMessageResult:(MessageResultModel *)modelMessageResult
{
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelMessageResult.headimg];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:imgURL placeholderImage:kPlaceholder];
    
    self.labelNickName.text = modelMessageResult.nickname;
    self.labelContent.text = modelMessageResult.content;
    self.labelTime.text = modelMessageResult.addtime;
}




@end
