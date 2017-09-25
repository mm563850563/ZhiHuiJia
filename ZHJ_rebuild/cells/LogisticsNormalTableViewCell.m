//
//  LogisticsNormalTableViewCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "LogisticsNormalTableViewCell.h"

#import "LogisticsRealTimeModel.h"

#import "GetHeightOfText.h"

@interface LogisticsNormalTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end

@implementation LogisticsNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelRealTime:(LogisticsRealTimeModel *)modelRealTime
{
    _modelRealTime = modelRealTime;
    
    self.labelContent.text = modelRealTime.context;
    self.labelTime.text = modelRealTime.time;
    
    CGFloat textHeight = [GetHeightOfText getHeightWithContent:modelRealTime.context font:15 contentSize:CGSizeMake(kSCREEN_WIDTH/7.0*6-20, MAXFLOAT)];
    
    self.cellHeight = textHeight + 50;
}





@end
