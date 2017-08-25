//
//  WaitToReviewActivityCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/25.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "WaitToReviewActivityCell.h"

#import "WaitToReviewActivityResultModel.h"

@interface WaitToReviewActivityCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgActivity;
@property (weak, nonatomic) IBOutlet UILabel *labelActivityTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@end

@implementation WaitToReviewActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelWaitToReviewResult:(WaitToReviewActivityResultModel *)modelWaitToReviewResult
{
    _modelWaitToReviewResult = modelWaitToReviewResult;
    self.labelActivityTitle.text = modelWaitToReviewResult.title;
    self.labelAddress.text = modelWaitToReviewResult.location;

    if ([self.reviewStatus isEqualToString:@"waitToReview"]) {
        self.labelStatus.text = @"审核中";
    }else if ([self.reviewStatus isEqualToString:@"alreadyPassed"]){
        self.labelStatus.text = @"已通过";
    }
    
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *dataFrom = [NSDate dateWithTimeIntervalSince1970:[modelWaitToReviewResult.start_time doubleValue]];
    NSDate *dateTo = [NSDate dateWithTimeIntervalSince1970:[modelWaitToReviewResult.end_time doubleValue]];
    
    NSString *dateFromStr = [formatter stringFromDate:dataFrom];
    NSString *dateToStr = [formatter stringFromDate:dateTo];
    
    self.labelTime.text = [NSString stringWithFormat:@"%@-%@",dateFromStr,dateToStr];
    
    //图片
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelWaitToReviewResult.image];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgActivity sd_setImageWithURL:url placeholderImage:kPlaceholder];
}

@end
