//
//  SelectTopic_TitleCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/4.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SelectTopic_TitleCell.h"
#import "SelectTopicResultModel.h"

@interface SelectTopic_TitleCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelTopicTitle;

@end

@implementation SelectTopic_TitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelSelectTopicResult:(SelectTopicResultModel *)modelSelectTopicResult
{
    _modelSelectTopicResult = modelSelectTopicResult;
    
    self.labelTopicTitle.text = modelSelectTopicResult.topic_title;
}








@end
