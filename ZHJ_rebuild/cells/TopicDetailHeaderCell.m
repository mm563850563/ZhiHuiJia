//
//  TopicDetailHeaderCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "TopicDetailHeaderCell.h"
#import "TopicDetailResultModel.h"

@interface TopicDetailHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewTopic;
@property (weak, nonatomic) IBOutlet UILabel *labelTopic;
@property (weak, nonatomic) IBOutlet UILabel *labelDynamicCount;

@end

@implementation TopicDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelResult:(TopicDetailResultModel *)modelResult
{
    _modelResult = modelResult;
    [self layoutIfNeeded];
    
    self.labelTopic.text = [NSString stringWithFormat:@"#%@#",modelResult.topic_title];
    self.labelDynamicCount.text = [NSString stringWithFormat:@"%@条新动态",modelResult.news];
    
    NSString *str = [NSString stringWithFormat:@"%@%@",kDomainImage,modelResult.banner];
    NSURL *url = [NSURL URLWithString:str];
    
    [self.imgViewTopic sd_setImageWithURL:url placeholderImage:kPlaceholder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize size = image.size;
        if (size.width <= 0 || size.height <= 0) {
            size = CGSizeMake(50, 50);
        }
        CGFloat scale = kSCREEN_WIDTH / size.width;
        CGFloat height = scale * size.height;
        self.cellHeight = height;
    }];
}


@end
