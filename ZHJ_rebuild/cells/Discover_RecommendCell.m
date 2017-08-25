//
//  Discover_RecommendCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/18.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "Discover_RecommendCell.h"

#import "ActivityListResultModel.h"

@interface Discover_RecommendCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgActivity;
@property (weak, nonatomic) IBOutlet UILabel *labelActivityTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelSignupCount;

@end

@implementation Discover_RecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelActivityResult:(ActivityListResultModel *)modelActivityResult
{
    _modelActivityResult = modelActivityResult;
    self.labelActivityTitle.text = modelActivityResult.title;
    self.labelAddress.text = modelActivityResult.location;
    self.labelSignupCount.text = modelActivityResult.signup_count;
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *dataFrom = [NSDate dateWithTimeIntervalSince1970:[modelActivityResult.start_time doubleValue]];
    NSDate *dateTo = [NSDate dateWithTimeIntervalSince1970:[modelActivityResult.end_time doubleValue]];
    
    NSString *dateFromStr = [formatter stringFromDate:dataFrom];
    NSString *dateToStr = [formatter stringFromDate:dateTo];
    
    self.labelTime.text = [NSString stringWithFormat:@"%@-%@",dateFromStr,dateToStr];
    
    //图片
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelActivityResult.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgActivity sd_setImageWithURL:url placeholderImage:kPlaceholder];
}








@end
