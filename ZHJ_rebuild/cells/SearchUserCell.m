//
//  SearchUserCell.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/27.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "SearchUserCell.h"
#import "SearchTopicOrUserUsers_infoModel.h"

@interface SearchUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPortrait;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;

@end

@implementation SearchUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModelUser_info:(SearchTopicOrUserUsers_infoModel *)modelUser_info
{
    _modelUser_info = modelUser_info;
    
    NSString *imgStr = [NSString stringWithFormat:@"%@%@",kDomainImage,modelUser_info.headimg];
    NSURL *url = [NSURL URLWithString:imgStr];
    [self.imgViewPortrait sd_setImageWithURL:url placeholderImage:kPlaceholder];
    
    self.labelNickName.text = [NSString stringWithFormat:@"%@",modelUser_info.nickname];
}


-(void)drawRect:(CGRect)rect
{
    CGFloat corner = self.imgViewPortrait.frame.size.width/2.0;
    self.imgViewPortrait.layer.cornerRadius = corner;
    self.imgViewPortrait.layer.masksToBounds = YES;
}







@end
