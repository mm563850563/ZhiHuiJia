//
//  PrivateLetterCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "PrivateLetterCell.h"

//tools
#import "UIButton+Badge.h"

@interface PrivateLetterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIButton *btnUnread;

@end

@implementation PrivateLetterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDictMessage:(NSDictionary *)dictMessage
{
    _dictMessage = dictMessage;
    
    //头像
    NSString *imgStr = dictMessage[@"headImg"];
    NSURL *imgURL = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:imgURL placeholderImage:kPlaceholder];
    //昵称
    NSString *nickName = dictMessage[@"nickName"];
    self.labelNickName.text = nickName;
    //时间
    NSString *timeStampStr = dictMessage[@"timeStamp"];
    double timeStamp = [timeStampStr doubleValue];
    NSTimeInterval timeInterval = timeStamp;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval/1000.0];
    NSString *dateStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    self.labelTime.text = dateStr;
    //未读消息数量
    NSString *unreadCount = dictMessage[@"unRead"];
    int count = [unreadCount intValue];
    self.btnUnread.shouldHideBadgeAtZero = YES;
    self.btnUnread.badgeValue = [NSString stringWithFormat:@"%d",count];
    self.btnUnread.badgeFont = [UIFont systemFontOfSize:10];
    self.btnUnread.badgeOriginX = self.btnUnread.bounds.size.width-10;
    //未读消息内容
    NSString *content = dictMessage[@"content"];
    self.labelContent.text = content;
}


-(void)drawRect:(CGRect)rect
{
    self.btnUnread.badgeOriginX = self.btnUnread.bounds.size.width-10;
}




@end
