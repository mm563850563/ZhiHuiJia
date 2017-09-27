//
//  SearchTopicCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SearchTopicCell.h"
#import "SearchTopicOrUserTopics_infoModel.h"

@interface SearchTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewTopic;
@property (weak, nonatomic) IBOutlet UILabel *labelTopicName;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentCount;
@property (weak, nonatomic) IBOutlet UILabel *labelLikeCount;

@end

@implementation SearchTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModelTopic_info:(SearchTopicOrUserTopics_infoModel *)modelTopic_info
{
    _modelTopic_info = modelTopic_info;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelTopic_info.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewTopic sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelTopicName.text = [NSString stringWithFormat:@"%@",modelTopic_info.topic_title];
    
    self.labelCommentCount.text = [NSString stringWithFormat:@"%@",modelTopic_info.reply_count];
    
    self.labelLikeCount.text = [NSString stringWithFormat:@"%@",modelTopic_info.like_count];
}








@end
