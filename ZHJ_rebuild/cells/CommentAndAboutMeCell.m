//
//  CommentAndAboutMeCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CommentAndAboutMeCell.h"
#import "MessageResultModel.h"

//tools
#import "UIButton+Badge.h"

@interface CommentAndAboutMeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIButton *btnUnread;

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
    
    if ([modelMessageResult.is_read isEqualToString:@"0"]) {
        self.btnUnread.badgeValue = @" ";
    }else{
        self.btnUnread.shouldHideBadgeAtZero = YES;
        self.btnUnread.badgeValue = @"0";
    }
    self.btnUnread.badgeFont = [UIFont systemFontOfSize:6];
}

-(void)drawRect:(CGRect)rect
{
    self.btnUnread.badgeOriginX = self.btnUnread.bounds.size.width-10;
}


@end
