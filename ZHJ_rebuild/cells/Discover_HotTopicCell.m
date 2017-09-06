//
//  Discover_HotTopicCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "Discover_HotTopicCell.h"

@interface Discover_HotTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewProduct;
@property (weak, nonatomic) IBOutlet UILabel *labelTopic;
@property (weak, nonatomic) IBOutlet UILabel *labelPraiseCount;
@property (weak, nonatomic) IBOutlet UILabel *labelCommentCount;

@end

@implementation Discover_HotTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModelTopicResult:(HotTopicListResultModel *)modelTopicResult
{
    _modelTopicResult = modelTopicResult;
    self.labelTopic.text = modelTopicResult.content;
    self.labelPraiseCount.text = modelTopicResult.like_count;
    self.labelCommentCount.text = modelTopicResult.reply_count;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelTopicResult.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewProduct sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
}

@end
